

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";



CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."app_role" AS ENUM (
    'admin',
    'member',
    'viewer'
);


ALTER TYPE "public"."app_role" OWNER TO "postgres";


COMMENT ON TYPE "public"."app_role" IS 'The role any user can endorse in the app';



CREATE TYPE "public"."incoterms" AS ENUM (
    'EXW',
    'FCA',
    'FAS',
    'FOB',
    'CFR',
    'CIF',
    'CPT',
    'CIP',
    'DAP',
    'DPU',
    'DDP'
);


ALTER TYPE "public"."incoterms" OWNER TO "postgres";


CREATE TYPE "public"."status_type" AS ENUM (
    'completed',
    'ongoing',
    'onhold',
    'closefollowuprequired',
    'critical'
);


ALTER TYPE "public"."status_type" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."can_user_access_company"("p_user_id" "uuid", "p_company_id" bigint) RETURNS boolean
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    AS $$
DECLARE v_tenant_id uuid; v_role character varying; v_has_specific_access boolean;
BEGIN
  SELECT tenant_id INTO v_tenant_id FROM public.companies WHERE id = p_company_id;
  IF NOT FOUND THEN RETURN FALSE; END IF;
  v_role := public.get_user_role_in_tenant(p_user_id, v_tenant_id);
  IF v_role = 'admin' THEN RETURN TRUE; END IF;
  IF v_role = 'member' OR v_role = 'viewer' THEN
    SELECT EXISTS (SELECT 1 FROM public.user_company_access WHERE user_id = p_user_id AND company_id = p_company_id) INTO v_has_specific_access;
    RETURN v_has_specific_access;
  END IF;
  RETURN FALSE;
END;
$$;


ALTER FUNCTION "public"."can_user_access_company"("p_user_id" "uuid", "p_company_id" bigint) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."can_user_access_project"("p_user_id" "uuid", "p_project_id" bigint) RETURNS boolean
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    AS $$
DECLARE v_company_id bigint; v_tenant_id uuid; v_role character varying; v_has_specific_access boolean;
BEGIN
    SELECT p.company_id, c.tenant_id INTO v_company_id, v_tenant_id FROM public.projects p JOIN public.companies c ON p.company_id = c.id WHERE p.id = p_project_id;
    IF NOT FOUND THEN RETURN FALSE; END IF;
    v_role := public.get_user_role_in_tenant(p_user_id, v_tenant_id);
    IF v_role = 'admin' THEN RETURN TRUE; END IF;
    IF v_role = 'member' OR v_role = 'viewer' THEN
        SELECT EXISTS (SELECT 1 FROM public.user_project_access WHERE user_id = p_user_id AND project_id = p_project_id) INTO v_has_specific_access;
        RETURN v_has_specific_access;
    END IF;
    RETURN FALSE;
END;
$$;


ALTER FUNCTION "public"."can_user_access_project"("p_user_id" "uuid", "p_project_id" bigint) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."custom_access_token_hook"("event" "jsonb") RETURNS "jsonb"
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    AS $$
DECLARE
  original_claims jsonb;
  new_claims jsonb;
  claim_key text;
  v_user_id uuid;
  tenant_id_to_set uuid;
  tenant_name_to_set text; -- Variable to hold the tenant name
  tenant_role_to_set text; -- Variable to hold the user tenant_role
  current_user_metadata jsonb; -- Variable to handle user_metadata modification
BEGIN
  -- 1. Extract original claims
  IF jsonb_typeof(event->'claims') = 'object' THEN
     original_claims := event->'claims';
  ELSE
     original_claims := '{}'::jsonb;
  END IF;

  -- 2. Initialize new claims
  new_claims := '{}'::jsonb;

  -- 3. Preserve required/desired claims (Including existing user_metadata)
  FOREACH claim_key IN ARRAY ARRAY[
      'iss', 'aud', 'exp', 'iat', 'sub', 'role', 'aal', 'session_id',
      'amr', 'jti', 'nbf', 'email', 'phone',
      'app_metadata', 'user_metadata', 'is_anonymous'
    ] LOOP
      IF original_claims ? claim_key THEN
        new_claims := jsonb_set(new_claims, array[claim_key], original_claims->claim_key);
      END IF;
  END LOOP;

  -- 4. Extract User ID
  IF new_claims ? 'sub' THEN
      BEGIN
         v_user_id := (new_claims->>'sub')::uuid;
      EXCEPTION WHEN invalid_text_representation THEN
         v_user_id := NULL; -- Handle case where 'sub' is not a valid UUID
      END;
  ELSE
      v_user_id := NULL; -- Ensure it's null if 'sub' is missing
  END IF;

  -- 5. Retrieve custom tenant_id AND tenant_name by joining tables
  IF v_user_id IS NOT NULL THEN
    BEGIN
      -- Query joining user_tenant_roles and tenants table
      -- Adjust 'public.tenants', 't.id', and 't.name' if your table/column names differ
      SELECT
         utr.tenant_id,
         t.name,  -- Get the tenant name
         utr.role
      INTO
         tenant_id_to_set,
         tenant_name_to_set,
         tenant_role_to_set
      FROM public.user_tenant_roles utr
      JOIN public.tenants t ON utr.tenant_id = t.id -- Join condition
      WHERE utr.user_id = v_user_id
      LIMIT 1;

    EXCEPTION WHEN others THEN
       -- Optional: Log error if needed using RAISE NOTICE for server logs
       -- RAISE NOTICE 'Custom hook query failed for user %: %', v_user_id, SQLERRM;
       tenant_id_to_set := NULL; -- Prevent partial data on error
       tenant_name_to_set := NULL;
       tenant_role_to_set := NULL;
    END;

    -- 6. Add claims IF data was found
    IF tenant_id_to_set IS NOT NULL THEN
      -- Add the custom tenant_id claim
      new_claims := jsonb_set(new_claims, '{tenant_id}', to_jsonb(tenant_id_to_set));

      -- Add tenant_name to user_metadata if found
      IF tenant_name_to_set IS NOT NULL THEN
          -- Get existing user_metadata or initialize as empty object
          current_user_metadata := new_claims->'user_metadata';
          IF jsonb_typeof(current_user_metadata) != 'object' THEN
              current_user_metadata := '{}'::jsonb;
          END IF;

          -- Add/Update the tenant_name key within user_metadata
          current_user_metadata := jsonb_set(current_user_metadata, '{tenant_name}', to_jsonb(tenant_name_to_set));

          -- Put the modified user_metadata back into the main claims object
          new_claims := jsonb_set(new_claims, '{user_metadata}', current_user_metadata);
      END IF; -- End if tenant_name found
      -- Add tenant_name to user_metadata if found
      IF tenant_role_to_set IS NOT NULL THEN
          -- Get existing user_metadata or initialize as empty object
          current_user_metadata := new_claims->'user_metadata';
          IF jsonb_typeof(current_user_metadata) != 'object' THEN
              current_user_metadata := '{}'::jsonb;
          END IF;

          -- Add/Update the tenant_name key within user_metadata
          current_user_metadata := jsonb_set(current_user_metadata, '{role}', to_jsonb(tenant_role_to_set));

          -- Put the modified user_metadata back into the main claims object
          new_claims := jsonb_set(new_claims, '{user_metadata}', current_user_metadata);
      END IF; -- End if tenant_name found

    END IF; -- End if tenant_id found

  END IF; -- End if v_user_id IS NOT NULL

  -- 7. Return the final claims object (no debug info)
  RETURN jsonb_build_object('claims', new_claims);

END;
$$;


ALTER FUNCTION "public"."custom_access_token_hook"("event" "jsonb") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_user_role_in_tenant"("p_user_id" "uuid", "p_tenant_id" "uuid") RETURNS character varying
    LANGUAGE "sql" STABLE SECURITY DEFINER
    AS $$
    SELECT role
    FROM public.user_tenant_roles
    WHERE user_id = p_user_id AND tenant_id = p_tenant_id;
$$;


ALTER FUNCTION "public"."get_user_role_in_tenant"("p_user_id" "uuid", "p_tenant_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  -- Insert a new row into public.user_profiles
  -- It copies the id and email from the new auth.users record
  -- It attempts to extract 'full_name' from the raw_user_meta_data JSON field
  INSERT INTO public.user_profiles (id, email, full_name)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data ->> 'full_name' -- Extracts the 'full_name' value as text. Will be NULL if missing.
  );
  RETURN NEW; -- Returns the new auth.users record (standard practice for AFTER triggers)
END;
$$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_tenant_admin"("check_tenant_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM user_tenant_roles
    WHERE user_tenant_roles.user_id = auth.uid()
      AND user_tenant_roles.tenant_id = check_tenant_id
      AND user_tenant_roles.role = 'admin' -- Or whatever your admin role is named
  );
END;
$$;


ALTER FUNCTION "public"."is_tenant_admin"("check_tenant_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."requesting_user_tenant_id"() RETURNS "uuid"
    LANGUAGE "sql" STABLE
    AS $$
  SELECT nullif(current_setting('request.jwt.claims', true)::jsonb ->> 'tenant_id', '')::uuid;
$$;


ALTER FUNCTION "public"."requesting_user_tenant_id"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."companies" (
    "id" bigint NOT NULL,
    "name" character varying NOT NULL,
    "tenant_id" "uuid" NOT NULL
);

ALTER TABLE ONLY "public"."companies" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."companies" OWNER TO "postgres";


COMMENT ON TABLE "public"."companies" IS 'Stores company information, linking companies to a specific tenant.';



ALTER TABLE "public"."companies" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."companies_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."contacts" (
    "id" bigint NOT NULL,
    "email" character varying NOT NULL,
    "cellphone_number" character varying,
    "office_phone_number" character varying,
    "first_name" character varying,
    "last_name" character varying,
    "company_id" bigint NOT NULL
);

ALTER TABLE ONLY "public"."contacts" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."contacts" OWNER TO "postgres";


COMMENT ON COLUMN "public"."contacts"."company_id" IS 'The company this contact belongs to.';



ALTER TABLE "public"."contacts" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."contact_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."deliverables" (
    "id" bigint NOT NULL,
    "title" character varying NOT NULL,
    "due_date" "date" NOT NULL,
    "is_received" boolean DEFAULT false NOT NULL,
    "parent_lot_id" bigint NOT NULL
);


ALTER TABLE "public"."deliverables" OWNER TO "postgres";


COMMENT ON TABLE "public"."deliverables" IS 'Associated with each lot, it contains the information about the documents required by the project engineer handed by the provider';



ALTER TABLE "public"."deliverables" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."deliverables_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."lots" (
    "id" bigint NOT NULL,
    "title" character varying NOT NULL,
    "number" character varying NOT NULL,
    "provider" character varying NOT NULL,
    "project_id" bigint NOT NULL,
    "assigned_expediter_id" "uuid"
);

ALTER TABLE ONLY "public"."lots" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."lots" OWNER TO "postgres";


ALTER TABLE "public"."lots" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."lot_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."lot_items" (
    "id" bigint NOT NULL,
    "title" character varying,
    "quantity" character varying,
    "end_manufacturing_date" "date",
    "ready_to_ship_date" "date",
    "purchasing_progress" smallint DEFAULT '0'::smallint NOT NULL,
    "engineering_progress" smallint DEFAULT '0'::smallint NOT NULL,
    "manufacturing_progress" smallint DEFAULT '0'::smallint NOT NULL,
    "origin_country" character varying,
    "incoterms" "public"."incoterms" NOT NULL,
    "comments" "text",
    "required_on_site_date" "date",
    "status" "public"."status_type" NOT NULL,
    "engineer_contact_id" bigint,
    "provider_project_manager_contact_id" bigint,
    "inspection_upcoming_dates" "date"[],
    "itp" boolean DEFAULT false NOT NULL,
    "final_acceptance_test_date" "date",
    "start_manufacturing_date" "date",
    "cwp" boolean DEFAULT false,
    "parent_lot_id" bigint NOT NULL,
    "planned_delivery_date" "date" NOT NULL
);

ALTER TABLE ONLY "public"."lot_items" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."lot_items" OWNER TO "postgres";


ALTER TABLE "public"."lot_items" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."lot_items_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."projects" (
    "id" bigint NOT NULL,
    "name" character varying NOT NULL,
    "company_id" bigint NOT NULL
);

ALTER TABLE ONLY "public"."projects" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."projects" OWNER TO "postgres";


COMMENT ON COLUMN "public"."projects"."company_id" IS 'References the company this project belongs to.';



CREATE TABLE IF NOT EXISTS "public"."reminders" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "note" "text",
    "due_date" "date",
    "is_completed" boolean DEFAULT false NOT NULL,
    "user_id" "uuid" NOT NULL,
    "project_id" bigint,
    "lot_id" bigint,
    "tenant_id" "uuid" NOT NULL
);


ALTER TABLE "public"."reminders" OWNER TO "postgres";


COMMENT ON COLUMN "public"."reminders"."is_completed" IS 'Tracks if the reminder task is done.';



COMMENT ON COLUMN "public"."reminders"."user_id" IS 'The user this reminder belongs to.';



COMMENT ON COLUMN "public"."reminders"."project_id" IS 'Optional project associated with this reminder.';



COMMENT ON COLUMN "public"."reminders"."lot_id" IS 'Optional lot associated with this reminder.';



COMMENT ON COLUMN "public"."reminders"."tenant_id" IS 'The tenant this reminder belongs to, ensuring data isolation.';



CREATE OR REPLACE VIEW "public"."project_dashboard_summary" WITH ("security_invoker"='on') AS
 WITH "lot_item_counts" AS (
         SELECT "l"."project_id",
            "count"("li"."id") AS "total_lot_items"
           FROM ("public"."lot_items" "li"
             JOIN "public"."lots" "l" ON (("li"."parent_lot_id" = "l"."id")))
          GROUP BY "l"."project_id"
        ), "upcoming_deliveries" AS (
         SELECT "l"."project_id",
            "count"("li"."id") AS "upcoming_deliveries_this_week_count"
           FROM ("public"."lot_items" "li"
             JOIN "public"."lots" "l" ON (("li"."parent_lot_id" = "l"."id")))
          WHERE (("li"."planned_delivery_date" >= CURRENT_DATE) AND ("li"."planned_delivery_date" < (CURRENT_DATE + '7 days'::interval)))
          GROUP BY "l"."project_id"
        ), "problematic_lots" AS (
         SELECT "l"."project_id",
            "count"(DISTINCT "li"."parent_lot_id") AS "problematic_lots_count"
           FROM ("public"."lot_items" "li"
             JOIN "public"."lots" "l" ON (("li"."parent_lot_id" = "l"."id")))
          WHERE (("li"."status")::"text" = 'critical'::"text")
          GROUP BY "l"."project_id"
        ), "important_reminders" AS (
         SELECT "r"."project_id",
            "count"(
                CASE
                    WHEN ("r"."due_date" < CURRENT_DATE) THEN "r"."id"
                    ELSE NULL::bigint
                END) AS "past_due_reminders_count",
            "count"(
                CASE
                    WHEN (("r"."due_date" >= CURRENT_DATE) AND ("r"."due_date" < (CURRENT_DATE + '3 days'::interval))) THEN "r"."id"
                    ELSE NULL::bigint
                END) AS "due_soon_reminders_count"
           FROM "public"."reminders" "r"
          WHERE (("r"."is_completed" = false) AND ("r"."project_id" IS NOT NULL))
          GROUP BY "r"."project_id"
        ), "project_deliverables" AS (
         SELECT "l"."project_id",
            "count"(
                CASE
                    WHEN ("d"."due_date" < CURRENT_DATE) THEN "d"."id"
                    ELSE NULL::bigint
                END) AS "past_due_deliverables_count",
            "count"(
                CASE
                    WHEN (("d"."due_date" >= CURRENT_DATE) AND ("d"."due_date" < (CURRENT_DATE + '7 days'::interval))) THEN "d"."id"
                    ELSE NULL::bigint
                END) AS "due_this_week_deliverables_count"
           FROM ("public"."deliverables" "d"
             JOIN "public"."lots" "l" ON (("d"."parent_lot_id" = "l"."id")))
          WHERE ("d"."is_received" = false)
          GROUP BY "l"."project_id"
        ), "project_progress" AS (
         SELECT "l"."project_id",
            "avg"(("li"."purchasing_progress")::numeric) AS "avg_purchasing_progress",
            "avg"(("li"."engineering_progress")::numeric) AS "avg_engineering_progress",
            "avg"(("li"."manufacturing_progress")::numeric) AS "avg_manufacturing_progress"
           FROM ("public"."lot_items" "li"
             JOIN "public"."lots" "l" ON (("li"."parent_lot_id" = "l"."id")))
          GROUP BY "l"."project_id"
        ), "project_data_quality" AS (
         SELECT "l"."project_id",
            "count"(*) FILTER (WHERE ("li"."start_manufacturing_date" IS NULL)) AS "missing_start_mfg_date_count",
            "count"(*) FILTER (WHERE ("li"."end_manufacturing_date" IS NULL)) AS "missing_end_mfg_date_count",
            "count"(*) FILTER (WHERE ("li"."planned_delivery_date" IS NULL)) AS "missing_planned_delivery_date_count",
            "count"(*) FILTER (WHERE ("li"."required_on_site_date" IS NULL)) AS "missing_required_on_site_date_count",
            "count"(*) FILTER (WHERE ("li"."engineer_contact_id" IS NULL)) AS "missing_engineer_contact_count",
            "count"(*) FILTER (WHERE ("li"."provider_project_manager_contact_id" IS NULL)) AS "missing_provider_pm_contact_count"
           FROM ("public"."lot_items" "li"
             JOIN "public"."lots" "l" ON (("li"."parent_lot_id" = "l"."id")))
          GROUP BY "l"."project_id"
        )
 SELECT "p"."id" AS "project_id",
    "p"."name" AS "project_name",
    COALESCE("lic"."total_lot_items", (0)::bigint) AS "total_lot_items",
    COALESCE("ud"."upcoming_deliveries_this_week_count", (0)::bigint) AS "upcoming_deliveries_this_week_count",
    COALESCE("pl"."problematic_lots_count", (0)::bigint) AS "problematic_lots_count",
    COALESCE("ir"."past_due_reminders_count", (0)::bigint) AS "past_due_reminders_count",
    COALESCE("ir"."due_soon_reminders_count", (0)::bigint) AS "due_soon_reminders_count",
    COALESCE("pdel"."past_due_deliverables_count", (0)::bigint) AS "past_due_deliverables_count",
    COALESCE("pdel"."due_this_week_deliverables_count", (0)::bigint) AS "due_this_week_deliverables_count",
    "round"(COALESCE("pp"."avg_purchasing_progress", (0)::numeric), 2) AS "avg_purchasing_progress",
    "round"(COALESCE("pp"."avg_engineering_progress", (0)::numeric), 2) AS "avg_engineering_progress",
    "round"(COALESCE("pp"."avg_manufacturing_progress", (0)::numeric), 2) AS "avg_manufacturing_progress",
    COALESCE("pdq"."missing_start_mfg_date_count", (0)::bigint) AS "missing_start_mfg_date_count",
    COALESCE("pdq"."missing_end_mfg_date_count", (0)::bigint) AS "missing_end_mfg_date_count",
    COALESCE("pdq"."missing_planned_delivery_date_count", (0)::bigint) AS "missing_planned_delivery_date_count",
    COALESCE("pdq"."missing_required_on_site_date_count", (0)::bigint) AS "missing_required_on_site_date_count",
    COALESCE("pdq"."missing_engineer_contact_count", (0)::bigint) AS "missing_engineer_contact_count",
    COALESCE("pdq"."missing_provider_pm_contact_count", (0)::bigint) AS "missing_provider_pm_contact_count"
   FROM ((((((("public"."projects" "p"
     LEFT JOIN "lot_item_counts" "lic" ON (("p"."id" = "lic"."project_id")))
     LEFT JOIN "upcoming_deliveries" "ud" ON (("p"."id" = "ud"."project_id")))
     LEFT JOIN "problematic_lots" "pl" ON (("p"."id" = "pl"."project_id")))
     LEFT JOIN "important_reminders" "ir" ON (("p"."id" = "ir"."project_id")))
     LEFT JOIN "project_deliverables" "pdel" ON (("p"."id" = "pdel"."project_id")))
     LEFT JOIN "project_progress" "pp" ON (("p"."id" = "pp"."project_id")))
     LEFT JOIN "project_data_quality" "pdq" ON (("p"."id" = "pdq"."project_id")));


ALTER TABLE "public"."project_dashboard_summary" OWNER TO "postgres";


ALTER TABLE "public"."projects" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."projects_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE OR REPLACE VIEW "public"."provider_performance_summary" WITH ("security_invoker"='on') AS
 WITH "provider_status_distribution" AS (
         SELECT "l"."provider",
            "count"(*) FILTER (WHERE (("li"."status")::"text" = 'completed'::"text")) AS "items_completed_count",
            "count"(*) FILTER (WHERE (("li"."status")::"text" = 'ongoing'::"text")) AS "items_ongoing_count",
            "count"(*) FILTER (WHERE (("li"."status")::"text" = 'onhold'::"text")) AS "items_onhold_count",
            "count"(*) FILTER (WHERE (("li"."status")::"text" = 'closefollowuprequired'::"text")) AS "items_closefollowup_count",
            "count"(*) FILTER (WHERE (("li"."status")::"text" = 'critical'::"text")) AS "items_critical_count",
            "count"("li"."id") AS "total_items_count"
           FROM ("public"."lot_items" "li"
             JOIN "public"."lots" "l" ON (("li"."parent_lot_id" = "l"."id")))
          GROUP BY "l"."provider"
        ), "provider_deliverable_performance" AS (
         SELECT "l"."provider",
            "count"("d"."id") AS "total_deliverables_count",
            "count"(*) FILTER (WHERE (("d"."is_received" = false) AND ("d"."due_date" < CURRENT_DATE))) AS "overdue_deliverables_count"
           FROM ("public"."deliverables" "d"
             JOIN "public"."lots" "l" ON (("d"."parent_lot_id" = "l"."id")))
          GROUP BY "l"."provider"
        ), "provider_avg_mfg_time" AS (
         SELECT "l"."provider",
            "avg"(("li"."end_manufacturing_date" - "li"."start_manufacturing_date")) AS "avg_manufacturing_interval"
           FROM ("public"."lot_items" "li"
             JOIN "public"."lots" "l" ON (("li"."parent_lot_id" = "l"."id")))
          WHERE (("li"."start_manufacturing_date" IS NOT NULL) AND ("li"."end_manufacturing_date" IS NOT NULL) AND ("li"."end_manufacturing_date" >= "li"."start_manufacturing_date"))
          GROUP BY "l"."provider"
        )
 SELECT "p"."provider",
    COALESCE("psd"."items_completed_count", (0)::bigint) AS "items_completed_count",
    COALESCE("psd"."items_ongoing_count", (0)::bigint) AS "items_ongoing_count",
    COALESCE("psd"."items_onhold_count", (0)::bigint) AS "items_onhold_count",
    COALESCE("psd"."items_closefollowup_count", (0)::bigint) AS "items_closefollowup_count",
    COALESCE("psd"."items_critical_count", (0)::bigint) AS "items_critical_count",
    COALESCE("psd"."total_items_count", (0)::bigint) AS "total_items_count",
    COALESCE("pdp"."total_deliverables_count", (0)::bigint) AS "total_deliverables_count",
    COALESCE("pdp"."overdue_deliverables_count", (0)::bigint) AS "overdue_deliverables_count",
        CASE
            WHEN (COALESCE("pdp"."total_deliverables_count", (0)::bigint) > 0) THEN "round"((((COALESCE("pdp"."overdue_deliverables_count", (0)::bigint))::numeric * 100.0) / ("pdp"."total_deliverables_count")::numeric), 2)
            ELSE (0)::numeric
        END AS "overdue_deliverables_percentage",
    "pamt"."avg_manufacturing_interval"
   FROM (((( SELECT DISTINCT "lots"."provider"
           FROM "public"."lots") "p"
     LEFT JOIN "provider_status_distribution" "psd" ON ((("p"."provider")::"text" = ("psd"."provider")::"text")))
     LEFT JOIN "provider_deliverable_performance" "pdp" ON ((("p"."provider")::"text" = ("pdp"."provider")::"text")))
     LEFT JOIN "provider_avg_mfg_time" "pamt" ON ((("p"."provider")::"text" = ("pamt"."provider")::"text")));


ALTER TABLE "public"."provider_performance_summary" OWNER TO "postgres";


ALTER TABLE "public"."reminders" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."reminders_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."tenants" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" character varying NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);

ALTER TABLE ONLY "public"."tenants" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."tenants" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."user_company_access" (
    "user_id" "uuid" NOT NULL,
    "company_id" bigint NOT NULL
);

ALTER TABLE ONLY "public"."user_company_access" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_company_access" OWNER TO "postgres";


COMMENT ON TABLE "public"."user_company_access" IS 'Grants specific users access to specific companies (used for non-admin roles).';



CREATE TABLE IF NOT EXISTS "public"."user_profiles" (
    "id" "uuid" NOT NULL,
    "email" character varying,
    "full_name" character varying,
    "created_at" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()) NOT NULL
);


ALTER TABLE "public"."user_profiles" OWNER TO "postgres";


COMMENT ON TABLE "public"."user_profiles" IS 'Stores public profile information for users, synced from auth.users.';



COMMENT ON COLUMN "public"."user_profiles"."id" IS 'References the unique identifier from the auth.users table.';



CREATE TABLE IF NOT EXISTS "public"."user_project_access" (
    "user_id" "uuid" NOT NULL,
    "project_id" bigint NOT NULL
);

ALTER TABLE ONLY "public"."user_project_access" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_project_access" OWNER TO "postgres";


COMMENT ON TABLE "public"."user_project_access" IS 'Grants specific users access to specific projects (used for non-admin roles).';



CREATE TABLE IF NOT EXISTS "public"."user_tenant_roles" (
    "user_id" "uuid" NOT NULL,
    "tenant_id" "uuid" NOT NULL,
    "role" character varying NOT NULL,
    CONSTRAINT "user_tenant_roles_role_check" CHECK ((("role")::"text" = ANY ((ARRAY['admin'::character varying, 'member'::character varying, 'viewer'::character varying])::"text"[])))
);

ALTER TABLE ONLY "public"."user_tenant_roles" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_tenant_roles" OWNER TO "postgres";


COMMENT ON TABLE "public"."user_tenant_roles" IS 'Assigns a primary role (admin, member, viewer) to a user within a specific tenant.';



COMMENT ON COLUMN "public"."user_tenant_roles"."role" IS 'Defines the maximum capability level within the tenant. Admins have full access. Member/Viewer access is further restricted by user_company_access and user_project_access tables.';



ALTER TABLE ONLY "public"."companies"
    ADD CONSTRAINT "companies_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."contacts"
    ADD CONSTRAINT "contact_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."deliverables"
    ADD CONSTRAINT "deliverables_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."lot_items"
    ADD CONSTRAINT "lot_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."lots"
    ADD CONSTRAINT "lot_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."projects"
    ADD CONSTRAINT "projects_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."reminders"
    ADD CONSTRAINT "reminders_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_company_access"
    ADD CONSTRAINT "user_company_access_pkey" PRIMARY KEY ("user_id", "company_id");



ALTER TABLE ONLY "public"."user_profiles"
    ADD CONSTRAINT "user_profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_project_access"
    ADD CONSTRAINT "user_project_access_pkey" PRIMARY KEY ("user_id", "project_id");



ALTER TABLE ONLY "public"."user_tenant_roles"
    ADD CONSTRAINT "user_tenant_roles_pkey" PRIMARY KEY ("user_id", "tenant_id");



CREATE INDEX "idx_companies_tenant_id" ON "public"."companies" USING "btree" ("tenant_id");



CREATE INDEX "idx_contacts_company_id" ON "public"."contacts" USING "btree" ("company_id");



CREATE INDEX "idx_reminders_due_date" ON "public"."reminders" USING "btree" ("due_date");



CREATE INDEX "idx_reminders_lot_id" ON "public"."reminders" USING "btree" ("lot_id");



CREATE INDEX "idx_reminders_project_id" ON "public"."reminders" USING "btree" ("project_id");



CREATE INDEX "idx_reminders_tenant_id" ON "public"."reminders" USING "btree" ("tenant_id");



CREATE INDEX "idx_reminders_user_id" ON "public"."reminders" USING "btree" ("user_id");



CREATE INDEX "idx_tenants_name" ON "public"."tenants" USING "btree" ("name");



CREATE INDEX "idx_user_company_access_company_id" ON "public"."user_company_access" USING "btree" ("company_id");



CREATE INDEX "idx_user_company_access_user_id" ON "public"."user_company_access" USING "btree" ("user_id");



CREATE INDEX "idx_user_profiles_email" ON "public"."user_profiles" USING "btree" ("email");



CREATE INDEX "idx_user_project_access_project_id" ON "public"."user_project_access" USING "btree" ("project_id");



CREATE INDEX "idx_user_project_access_user_id" ON "public"."user_project_access" USING "btree" ("user_id");



ALTER TABLE ONLY "public"."companies"
    ADD CONSTRAINT "companies_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."contacts"
    ADD CONSTRAINT "contacts_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "public"."companies"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."deliverables"
    ADD CONSTRAINT "deliverables_parent_lot_id_fkey" FOREIGN KEY ("parent_lot_id") REFERENCES "public"."lots"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."lot_items"
    ADD CONSTRAINT "lot_items_engineer_contact_id_fkey" FOREIGN KEY ("engineer_contact_id") REFERENCES "public"."contacts"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."lot_items"
    ADD CONSTRAINT "lot_items_parent_lot_id_fkey" FOREIGN KEY ("parent_lot_id") REFERENCES "public"."lots"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."lot_items"
    ADD CONSTRAINT "lot_items_provider_project_manager_contact_id_fkey" FOREIGN KEY ("provider_project_manager_contact_id") REFERENCES "public"."contacts"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."lots"
    ADD CONSTRAINT "lots_assigned_expediter_id_fkey" FOREIGN KEY ("assigned_expediter_id") REFERENCES "public"."user_profiles"("id") ON UPDATE CASCADE ON DELETE SET NULL;



ALTER TABLE ONLY "public"."lots"
    ADD CONSTRAINT "lots_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "public"."projects"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."projects"
    ADD CONSTRAINT "projects_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "public"."companies"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."reminders"
    ADD CONSTRAINT "reminders_lot_id_fkey" FOREIGN KEY ("lot_id") REFERENCES "public"."lots"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."reminders"
    ADD CONSTRAINT "reminders_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "public"."projects"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."reminders"
    ADD CONSTRAINT "reminders_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_company_access"
    ADD CONSTRAINT "user_company_access_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "public"."companies"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_company_access"
    ADD CONSTRAINT "user_company_access_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_profiles"
    ADD CONSTRAINT "user_profiles_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_project_access"
    ADD CONSTRAINT "user_project_access_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "public"."projects"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_project_access"
    ADD CONSTRAINT "user_project_access_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_tenant_roles"
    ADD CONSTRAINT "user_tenant_roles_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_tenant_roles"
    ADD CONSTRAINT "user_tenant_roles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_tenant_roles"
    ADD CONSTRAINT "user_tenant_roles_user_profiles_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user_profiles"("id") ON DELETE CASCADE;



CREATE POLICY "Allow access to profiles within shared tenants" ON "public"."user_profiles" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM ("public"."user_tenant_roles" "utr1"
     JOIN "public"."user_tenant_roles" "utr2" ON (("utr1"."tenant_id" = "utr2"."tenant_id")))
  WHERE (("utr1"."user_id" = "auth"."uid"()) AND ("utr2"."user_id" = "user_profiles"."id")))));



CREATE POLICY "Allow admin insert access within their tenants" ON "public"."user_tenant_roles" FOR INSERT TO "authenticated" WITH CHECK ((("public"."get_user_role_in_tenant"("auth"."uid"(), "tenant_id"))::"text" = 'admin'::"text"));



CREATE POLICY "Allow admin read access within their tenants" ON "public"."user_tenant_roles" FOR SELECT TO "authenticated" USING ((("public"."get_user_role_in_tenant"("auth"."uid"(), "tenant_id"))::"text" = 'admin'::"text"));



CREATE POLICY "Allow admin update access within their tenants" ON "public"."user_tenant_roles" FOR UPDATE TO "authenticated" USING ((("public"."get_user_role_in_tenant"("auth"."uid"(), "tenant_id"))::"text" = 'admin'::"text")) WITH CHECK (((("public"."get_user_role_in_tenant"("auth"."uid"(), "tenant_id"))::"text" = 'admin'::"text") AND ("user_id" <> "auth"."uid"()) AND ((( SELECT "existing_role"."role"
   FROM "public"."user_tenant_roles" "existing_role"
  WHERE (("existing_role"."user_id" = "user_tenant_roles"."user_id") AND ("existing_role"."tenant_id" = "user_tenant_roles"."tenant_id"))))::"text" <> 'admin'::"text")));



CREATE POLICY "Allow authenticated users to delete contacts for their company " ON "public"."contacts" FOR DELETE TO "authenticated" USING (("public"."can_user_access_company"("auth"."uid"(), "company_id") AND (("public"."get_user_role_in_tenant"("auth"."uid"(), ( SELECT "companies"."tenant_id"
   FROM "public"."companies"
  WHERE ("companies"."id" = "contacts"."company_id"))))::"text" = ANY ((ARRAY['admin'::character varying, 'member'::character varying])::"text"[]))));



CREATE POLICY "Allow authenticated users to insert contacts for their company " ON "public"."contacts" FOR INSERT TO "authenticated" WITH CHECK (("public"."can_user_access_company"("auth"."uid"(), "company_id") AND (("public"."get_user_role_in_tenant"("auth"."uid"(), ( SELECT "companies"."tenant_id"
   FROM "public"."companies"
  WHERE ("companies"."id" = "contacts"."company_id"))))::"text" = ANY ((ARRAY['admin'::character varying, 'member'::character varying])::"text"[]))));



CREATE POLICY "Allow authenticated users to select contacts for their company " ON "public"."contacts" FOR SELECT TO "authenticated" USING (("public"."can_user_access_company"("auth"."uid"(), "company_id") AND (("public"."get_user_role_in_tenant"("auth"."uid"(), ( SELECT "companies"."tenant_id"
   FROM "public"."companies"
  WHERE ("companies"."id" = "contacts"."company_id"))))::"text" = ANY ((ARRAY['admin'::character varying, 'member'::character varying])::"text"[]))));



CREATE POLICY "Allow authenticated users to update contacts for their company " ON "public"."contacts" FOR UPDATE TO "authenticated" USING (("public"."can_user_access_company"("auth"."uid"(), "company_id") AND (("public"."get_user_role_in_tenant"("auth"."uid"(), ( SELECT "companies"."tenant_id"
   FROM "public"."companies"
  WHERE ("companies"."id" = "contacts"."company_id"))))::"text" = ANY ((ARRAY['admin'::character varying, 'member'::character varying])::"text"[])))) WITH CHECK (("public"."can_user_access_company"("auth"."uid"(), "company_id") AND (("public"."get_user_role_in_tenant"("auth"."uid"(), ( SELECT "companies"."tenant_id"
   FROM "public"."companies"
  WHERE ("companies"."id" = "contacts"."company_id"))))::"text" = ANY ((ARRAY['admin'::character varying, 'member'::character varying])::"text"[]))));



CREATE POLICY "Allow individual read access" ON "public"."user_profiles" FOR SELECT TO "authenticated" USING (("auth"."uid"() = "id"));



CREATE POLICY "Allow individual update access" ON "public"."user_profiles" FOR UPDATE TO "authenticated" USING (("auth"."uid"() = "id")) WITH CHECK (("auth"."uid"() = "id"));



CREATE POLICY "Allow users to view their own tenant links" ON "public"."user_tenant_roles" FOR SELECT TO "authenticated" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Disallow direct deletes" ON "public"."user_profiles" FOR DELETE USING (false);



CREATE POLICY "Disallow direct inserts" ON "public"."user_profiles" FOR INSERT WITH CHECK (false);



CREATE POLICY "Tenant admins can delete any reminder in their tenant" ON "public"."reminders" FOR DELETE USING ("public"."is_tenant_admin"("tenant_id"));



CREATE POLICY "Tenant admins can insert any reminder in their tenant" ON "public"."reminders" FOR INSERT WITH CHECK ("public"."is_tenant_admin"("tenant_id"));



CREATE POLICY "Tenant admins can update any reminder in their tenant" ON "public"."reminders" FOR UPDATE USING ("public"."is_tenant_admin"("tenant_id")) WITH CHECK ("public"."is_tenant_admin"("tenant_id"));



CREATE POLICY "Tenant admins can view all reminders in their tenant" ON "public"."reminders" FOR SELECT USING ("public"."is_tenant_admin"("tenant_id"));



CREATE POLICY "Users can delete their own reminders" ON "public"."reminders" FOR DELETE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can insert reminders for themselves within their tenants" ON "public"."reminders" FOR INSERT WITH CHECK ((("auth"."uid"() = "user_id") AND (EXISTS ( SELECT 1
   FROM "public"."user_tenant_roles" "utr"
  WHERE (("utr"."user_id" = "auth"."uid"()) AND ("utr"."tenant_id" = "reminders"."tenant_id"))))));



CREATE POLICY "Users can update their own reminders" ON "public"."reminders" FOR UPDATE USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can view their own reminders" ON "public"."reminders" FOR SELECT USING (("auth"."uid"() = "user_id"));



ALTER TABLE "public"."companies" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."contacts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."deliverables" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."lot_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."lots" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "manage_companies_for_admins" ON "public"."companies" TO "authenticated" USING ((("public"."get_user_role_in_tenant"("auth"."uid"(), "tenant_id"))::"text" = 'admin'::"text")) WITH CHECK ((("public"."get_user_role_in_tenant"("auth"."uid"(), "tenant_id"))::"text" = 'admin'::"text"));



CREATE POLICY "manage_company_access_for_admins" ON "public"."user_company_access" TO "authenticated" USING (((( SELECT "public"."get_user_role_in_tenant"("auth"."uid"(), "c"."tenant_id") AS "get_user_role_in_tenant"
   FROM "public"."companies" "c"
  WHERE ("c"."id" = "user_company_access"."company_id")))::"text" = 'admin'::"text")) WITH CHECK (((( SELECT "public"."get_user_role_in_tenant"("auth"."uid"(), "c"."tenant_id") AS "get_user_role_in_tenant"
   FROM "public"."companies" "c"
  WHERE ("c"."id" = "user_company_access"."company_id")))::"text" = 'admin'::"text"));



CREATE POLICY "manage_deliverables_admin_and_members" ON "public"."deliverables" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM (("public"."lots" "l"
     JOIN "public"."projects" "p" ON (("l"."project_id" = "p"."id")))
     JOIN "public"."companies" "c" ON (("p"."company_id" = "c"."id")))
  WHERE (("l"."id" = "deliverables"."parent_lot_id") AND (("public"."get_user_role_in_tenant"("auth"."uid"(), "c"."tenant_id"))::"text" = ANY (ARRAY['admin'::"text", 'member'::"text"])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (("public"."lots" "l"
     JOIN "public"."projects" "p" ON (("l"."project_id" = "p"."id")))
     JOIN "public"."companies" "c" ON (("p"."company_id" = "c"."id")))
  WHERE (("l"."id" = "deliverables"."parent_lot_id") AND (("public"."get_user_role_in_tenant"("auth"."uid"(), "c"."tenant_id"))::"text" = ANY (ARRAY['admin'::"text", 'member'::"text"]))))));



CREATE POLICY "manage_lot_items_for_admins_and_members" ON "public"."lot_items" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM (("public"."lots" "l"
     JOIN "public"."projects" "p" ON (("l"."project_id" = "p"."id")))
     JOIN "public"."companies" "c" ON (("p"."company_id" = "c"."id")))
  WHERE (("l"."id" = "lot_items"."parent_lot_id") AND (("public"."get_user_role_in_tenant"("auth"."uid"(), "c"."tenant_id"))::"text" = ANY (ARRAY['admin'::"text", 'member'::"text"])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (("public"."lots" "l"
     JOIN "public"."projects" "p" ON (("l"."project_id" = "p"."id")))
     JOIN "public"."companies" "c" ON (("p"."company_id" = "c"."id")))
  WHERE (("l"."id" = "lot_items"."parent_lot_id") AND (("public"."get_user_role_in_tenant"("auth"."uid"(), "c"."tenant_id"))::"text" = ANY (ARRAY['admin'::"text", 'member'::"text"]))))));



CREATE POLICY "manage_lots_for_admins_and_members" ON "public"."lots" TO "authenticated" USING (((( SELECT "public"."get_user_role_in_tenant"("auth"."uid"(), "c"."tenant_id") AS "get_user_role_in_tenant"
   FROM ("public"."projects" "p"
     JOIN "public"."companies" "c" ON (("p"."company_id" = "c"."id")))
  WHERE ("p"."id" = "lots"."project_id")))::"text" = ANY (ARRAY['admin'::"text", 'member'::"text"]))) WITH CHECK (((( SELECT "public"."get_user_role_in_tenant"("auth"."uid"(), "c"."tenant_id") AS "get_user_role_in_tenant"
   FROM ("public"."projects" "p"
     JOIN "public"."companies" "c" ON (("p"."company_id" = "c"."id")))
  WHERE ("p"."id" = "lots"."project_id")))::"text" = ANY (ARRAY['admin'::"text", 'member'::"text"])));



CREATE POLICY "manage_project_access_for_admins" ON "public"."user_project_access" TO "authenticated" USING (((( SELECT "public"."get_user_role_in_tenant"("auth"."uid"(), "c"."tenant_id") AS "get_user_role_in_tenant"
   FROM ("public"."projects" "p"
     JOIN "public"."companies" "c" ON (("p"."company_id" = "c"."id")))
  WHERE ("p"."id" = "user_project_access"."project_id")))::"text" = 'admin'::"text")) WITH CHECK (((( SELECT "public"."get_user_role_in_tenant"("auth"."uid"(), "c"."tenant_id") AS "get_user_role_in_tenant"
   FROM ("public"."projects" "p"
     JOIN "public"."companies" "c" ON (("p"."company_id" = "c"."id")))
  WHERE ("p"."id" = "user_project_access"."project_id")))::"text" = 'admin'::"text"));



CREATE POLICY "manage_projects_for_admins" ON "public"."projects" TO "authenticated" USING (((( SELECT "public"."get_user_role_in_tenant"("auth"."uid"(), "c"."tenant_id") AS "get_user_role_in_tenant"
   FROM "public"."companies" "c"
  WHERE ("c"."id" = "projects"."company_id")))::"text" = 'admin'::"text")) WITH CHECK (((( SELECT "public"."get_user_role_in_tenant"("auth"."uid"(), "c"."tenant_id") AS "get_user_role_in_tenant"
   FROM "public"."companies" "c"
  WHERE ("c"."id" = "projects"."company_id")))::"text" = 'admin'::"text"));



ALTER TABLE "public"."projects" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."reminders" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "select_company_if_allowed" ON "public"."companies" FOR SELECT TO "authenticated" USING ("public"."can_user_access_company"("auth"."uid"(), "id"));



CREATE POLICY "select_deliverables_if_project_access" ON "public"."deliverables" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."lots" "l"
  WHERE (("l"."id" = "deliverables"."parent_lot_id") AND "public"."can_user_access_project"("auth"."uid"(), "l"."project_id")))));



CREATE POLICY "select_lot_items_if_project_allowed" ON "public"."lot_items" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."lots" "l"
  WHERE (("l"."id" = "lot_items"."parent_lot_id") AND "public"."can_user_access_project"("auth"."uid"(), "l"."project_id")))));



CREATE POLICY "select_lots_if_project_allowed" ON "public"."lots" FOR SELECT TO "authenticated" USING ("public"."can_user_access_project"("auth"."uid"(), "project_id"));



CREATE POLICY "select_own_or_admin_company_access" ON "public"."user_company_access" FOR SELECT TO "authenticated" USING ((("user_id" = "auth"."uid"()) OR ((( SELECT "public"."get_user_role_in_tenant"("auth"."uid"(), "c"."tenant_id") AS "get_user_role_in_tenant"
   FROM "public"."companies" "c"
  WHERE ("c"."id" = "user_company_access"."company_id")))::"text" = 'admin'::"text")));



CREATE POLICY "select_own_or_admin_project_access" ON "public"."user_project_access" FOR SELECT TO "authenticated" USING ((("user_id" = "auth"."uid"()) OR ((( SELECT "public"."get_user_role_in_tenant"("auth"."uid"(), "c"."tenant_id") AS "get_user_role_in_tenant"
   FROM ("public"."projects" "p"
     JOIN "public"."companies" "c" ON (("p"."company_id" = "c"."id")))
  WHERE ("p"."id" = "user_project_access"."project_id")))::"text" = 'admin'::"text")));



CREATE POLICY "select_project_if_allowed" ON "public"."projects" FOR SELECT TO "authenticated" USING ("public"."can_user_access_project"("auth"."uid"(), "id"));



CREATE POLICY "select_tenant_if_member" ON "public"."tenants" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."user_tenant_roles" "utr"
  WHERE (("utr"."user_id" = "auth"."uid"()) AND ("utr"."tenant_id" = "tenants"."id")))));



ALTER TABLE "public"."tenants" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_company_access" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_profiles" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_project_access" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."user_tenant_roles" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";
GRANT USAGE ON SCHEMA "public" TO "supabase_auth_admin";

















































































































































































GRANT ALL ON FUNCTION "public"."can_user_access_company"("p_user_id" "uuid", "p_company_id" bigint) TO "anon";
GRANT ALL ON FUNCTION "public"."can_user_access_company"("p_user_id" "uuid", "p_company_id" bigint) TO "authenticated";
GRANT ALL ON FUNCTION "public"."can_user_access_company"("p_user_id" "uuid", "p_company_id" bigint) TO "service_role";



GRANT ALL ON FUNCTION "public"."can_user_access_project"("p_user_id" "uuid", "p_project_id" bigint) TO "anon";
GRANT ALL ON FUNCTION "public"."can_user_access_project"("p_user_id" "uuid", "p_project_id" bigint) TO "authenticated";
GRANT ALL ON FUNCTION "public"."can_user_access_project"("p_user_id" "uuid", "p_project_id" bigint) TO "service_role";



REVOKE ALL ON FUNCTION "public"."custom_access_token_hook"("event" "jsonb") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."custom_access_token_hook"("event" "jsonb") TO "service_role";
GRANT ALL ON FUNCTION "public"."custom_access_token_hook"("event" "jsonb") TO "supabase_auth_admin";



GRANT ALL ON FUNCTION "public"."get_user_role_in_tenant"("p_user_id" "uuid", "p_tenant_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_user_role_in_tenant"("p_user_id" "uuid", "p_tenant_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_user_role_in_tenant"("p_user_id" "uuid", "p_tenant_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."is_tenant_admin"("check_tenant_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."is_tenant_admin"("check_tenant_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_tenant_admin"("check_tenant_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."requesting_user_tenant_id"() TO "anon";
GRANT ALL ON FUNCTION "public"."requesting_user_tenant_id"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."requesting_user_tenant_id"() TO "service_role";


















GRANT ALL ON TABLE "public"."companies" TO "anon";
GRANT ALL ON TABLE "public"."companies" TO "authenticated";
GRANT ALL ON TABLE "public"."companies" TO "service_role";



GRANT ALL ON SEQUENCE "public"."companies_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."companies_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."companies_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."contacts" TO "anon";
GRANT ALL ON TABLE "public"."contacts" TO "authenticated";
GRANT ALL ON TABLE "public"."contacts" TO "service_role";



GRANT ALL ON SEQUENCE "public"."contact_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."contact_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."contact_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."deliverables" TO "anon";
GRANT ALL ON TABLE "public"."deliverables" TO "authenticated";
GRANT ALL ON TABLE "public"."deliverables" TO "service_role";



GRANT ALL ON SEQUENCE "public"."deliverables_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."deliverables_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."deliverables_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."lots" TO "anon";
GRANT ALL ON TABLE "public"."lots" TO "authenticated";
GRANT ALL ON TABLE "public"."lots" TO "service_role";



GRANT ALL ON SEQUENCE "public"."lot_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."lot_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."lot_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."lot_items" TO "anon";
GRANT ALL ON TABLE "public"."lot_items" TO "authenticated";
GRANT ALL ON TABLE "public"."lot_items" TO "service_role";



GRANT ALL ON SEQUENCE "public"."lot_items_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."lot_items_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."lot_items_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."projects" TO "anon";
GRANT ALL ON TABLE "public"."projects" TO "authenticated";
GRANT ALL ON TABLE "public"."projects" TO "service_role";



GRANT ALL ON TABLE "public"."reminders" TO "anon";
GRANT ALL ON TABLE "public"."reminders" TO "authenticated";
GRANT ALL ON TABLE "public"."reminders" TO "service_role";



GRANT ALL ON TABLE "public"."project_dashboard_summary" TO "anon";
GRANT ALL ON TABLE "public"."project_dashboard_summary" TO "authenticated";
GRANT ALL ON TABLE "public"."project_dashboard_summary" TO "service_role";



GRANT ALL ON SEQUENCE "public"."projects_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."projects_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."projects_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."provider_performance_summary" TO "anon";
GRANT ALL ON TABLE "public"."provider_performance_summary" TO "authenticated";
GRANT ALL ON TABLE "public"."provider_performance_summary" TO "service_role";



GRANT ALL ON SEQUENCE "public"."reminders_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."reminders_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."reminders_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."tenants" TO "anon";
GRANT ALL ON TABLE "public"."tenants" TO "authenticated";
GRANT ALL ON TABLE "public"."tenants" TO "service_role";



GRANT ALL ON TABLE "public"."user_company_access" TO "anon";
GRANT ALL ON TABLE "public"."user_company_access" TO "authenticated";
GRANT ALL ON TABLE "public"."user_company_access" TO "service_role";



GRANT ALL ON TABLE "public"."user_profiles" TO "anon";
GRANT ALL ON TABLE "public"."user_profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."user_profiles" TO "service_role";



GRANT ALL ON TABLE "public"."user_project_access" TO "anon";
GRANT ALL ON TABLE "public"."user_project_access" TO "authenticated";
GRANT ALL ON TABLE "public"."user_project_access" TO "service_role";



GRANT ALL ON TABLE "public"."user_tenant_roles" TO "anon";
GRANT ALL ON TABLE "public"."user_tenant_roles" TO "authenticated";
GRANT ALL ON TABLE "public"."user_tenant_roles" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;
