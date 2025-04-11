create policy "Admin can select users from same tenant"
on "auth"."users"
as permissive
for select
to authenticated
using ((EXISTS ( SELECT 1
   FROM (user_tenant_roles utr_target_user
     JOIN user_tenant_roles utr_current_admin ON ((utr_target_user.tenant_id = utr_current_admin.tenant_id)))
  WHERE ((utr_target_user.user_id = users.id) AND (utr_current_admin.user_id = auth.uid()) AND ((utr_current_admin.role)::text = 'admin'::text)))));


create policy "Allow users to select own data"
on "auth"."users"
as permissive
for select
to authenticated
using ((auth.uid() = id));


CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION handle_new_user();


