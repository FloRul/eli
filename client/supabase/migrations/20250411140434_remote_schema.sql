drop policy "Allow authenticated users to delete contacts for their company " on "public"."contacts";

drop policy "Allow authenticated users to insert contacts for their company " on "public"."contacts";

drop policy "Allow authenticated users to select contacts for their company " on "public"."contacts";

drop policy "Allow authenticated users to update contacts for their company " on "public"."contacts";

alter table "public"."user_tenant_roles" drop constraint "user_tenant_roles_role_check";

alter table "public"."user_tenant_roles" add constraint "user_tenant_roles_role_check" CHECK (((role)::text = ANY ((ARRAY['admin'::character varying, 'member'::character varying, 'viewer'::character varying])::text[]))) not valid;

alter table "public"."user_tenant_roles" validate constraint "user_tenant_roles_role_check";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_user_role_in_tenant(p_user_id uuid, p_tenant_id uuid)
 RETURNS character varying
 LANGUAGE sql
 STABLE SECURITY DEFINER
AS $function$
    SELECT role
    FROM public.user_tenant_roles
    WHERE user_id = p_user_id AND tenant_id = p_tenant_id;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION public.is_tenant_admin(check_tenant_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM user_tenant_roles
    WHERE user_tenant_roles.user_id = auth.uid()
      AND user_tenant_roles.tenant_id = check_tenant_id
      AND user_tenant_roles.role = 'admin' -- Or whatever your admin role is named
  );
END;
$function$
;

create policy "Allow authenticated users to delete contacts for their company "
on "public"."contacts"
as permissive
for delete
to authenticated
using ((can_user_access_company(auth.uid(), company_id) AND ((get_user_role_in_tenant(auth.uid(), ( SELECT companies.tenant_id
   FROM companies
  WHERE (companies.id = contacts.company_id))))::text = ANY ((ARRAY['admin'::character varying, 'member'::character varying])::text[]))));


create policy "Allow authenticated users to insert contacts for their company "
on "public"."contacts"
as permissive
for insert
to authenticated
with check ((can_user_access_company(auth.uid(), company_id) AND ((get_user_role_in_tenant(auth.uid(), ( SELECT companies.tenant_id
   FROM companies
  WHERE (companies.id = contacts.company_id))))::text = ANY ((ARRAY['admin'::character varying, 'member'::character varying])::text[]))));


create policy "Allow authenticated users to select contacts for their company "
on "public"."contacts"
as permissive
for select
to authenticated
using ((can_user_access_company(auth.uid(), company_id) AND ((get_user_role_in_tenant(auth.uid(), ( SELECT companies.tenant_id
   FROM companies
  WHERE (companies.id = contacts.company_id))))::text = ANY ((ARRAY['admin'::character varying, 'member'::character varying])::text[]))));


create policy "Allow authenticated users to update contacts for their company "
on "public"."contacts"
as permissive
for update
to authenticated
using ((can_user_access_company(auth.uid(), company_id) AND ((get_user_role_in_tenant(auth.uid(), ( SELECT companies.tenant_id
   FROM companies
  WHERE (companies.id = contacts.company_id))))::text = ANY ((ARRAY['admin'::character varying, 'member'::character varying])::text[]))))
with check ((can_user_access_company(auth.uid(), company_id) AND ((get_user_role_in_tenant(auth.uid(), ( SELECT companies.tenant_id
   FROM companies
  WHERE (companies.id = contacts.company_id))))::text = ANY ((ARRAY['admin'::character varying, 'member'::character varying])::text[]))));



