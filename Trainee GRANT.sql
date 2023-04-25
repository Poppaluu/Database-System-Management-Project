CREATE ROLE trainee WITH LOGIN;
GRANT SELECT ON project TO trainee;
GRANT SELECT ON customer TO trainee;
GRANT SELECT ON geo_location TO trainee;
GRANT SELECT ON project_role TO trainee;
GRANT SELECT (e_id, emp_name, email) ON employee TO trainee;
