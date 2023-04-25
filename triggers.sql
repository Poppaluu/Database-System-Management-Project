CREATE OR REPLACE FUNCTION check_duplicate_skills() 
RETURNS TRIGGER 
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM skills WHERE skill = NEW.skill) THEN
        RAISE EXCEPTION 'Skill % already exists', NEW.skill;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--CREATE TRIGGER check_skills_duplicate
--BEFORE INSERT ON skills
--FOR EACH ROW
--EXECUTE FUNCTION check_duplicate_skills();

--INSERT INTO skills VALUES (37, 'MySQL', false, 0);

SELECT * FROM employee;



CREATE OR REPLACE FUNCTION contract_temporary_date_check() RETURNS TRIGGER 
AS $$
BEGIN
    NEW.contract_start = current_date;
	
    IF NEW.contract_type = 'Temporary' THEN
        NEW.contract_end = NEW.contract_start + interval '2 years';
    ELSE
        NEW.contract_end = NULL;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--CREATE TRIGGER temporary_contract_trigger
--BEFORE UPDATE ON employee
--FOR EACH ROW
--WHEN (OLD.contract_type <> NEW.contract_type OR OLD.contract_start <> NEW.contract_start OR OLD.contract_end <> NEW.contract_end)
--EXECUTE FUNCTION contract_temporary_date_check();

UPDATE employee
SET contract_type = 'Full-time', contract_start = '2011-03-20'
WHERE e_id = 259;

SELECT * FROM employee;


CREATE OR REPLACE FUNCTION three_workers() RETURNS TRIGGER 
AS $$
DECLARE
	customer_country VARCHAR(255);
BEGIN
    SELECT geo_location.country INTO STRICT customer_country
    FROM customer
    JOIN geo_location ON customer.l_id = geo_location.l_id
	WHERE customer.c_id = NEW.c_id;
	
	INSERT INTO project_role (e_id, p_id, prole_start_date)
	SELECT employee.e_id, NEW.p_id, NEW.p_start_date 
	FROM employee
	JOIN employee_country ON employee.e_id = employee_country.employee_id
	WHERE employee_country.country = customer_country
	AND NOT EXISTS (
  	SELECT 1 FROM project_role WHERE project_role.e_id = employee.e_id
)
LIMIT 3;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


--CREATE TRIGGER assign_workers
--AFTER INSERT ON project
--FOR EACH ROW
--EXECUTE FUNCTION three_workers();

SELECT * FROM customer JOIN geo_location ON customer.l_id = geo_location.l_id;

INSERT INTO project (project_name, budget, commission_percentage, p_start_date, p_end_date, c_id)
VALUES ('Test8', 1000000, 0.1, '2023-05-01', '2024-05-01', 2);

SELECT * FROM project_role JOIN employee_country ON employee_country.employee_id = project_role.e_id WHERE p_id >= 1021 ORDER BY p_id ASC;

/*
SELECT employee.e_id
FROM employee
WHERE NOT EXISTS (
  SELECT 1 FROM project_role WHERE project_role.e_id = employee.e_id
);
*/
--SELECT * FROM project_members;
