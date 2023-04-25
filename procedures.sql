CREATE OR REPLACE PROCEDURE set_base_salary() AS
$$
BEGIN
  UPDATE employee
  SET salary = job_title.base_salary
  FROM job_title
  WHERE employee.j_id = job_title.j_id;
END;
$$
LANGUAGE plpgsql;

CALL set_base_salary();

SELECT * FROM employee;


 
CREATE OR REPLACE PROCEDURE increase_contract() AS
$$
BEGIN
	UPDATE employee
	SET contract_end = contract_end + INTERVAL '3 MONTHS'
	WHERE contract_type = 'Temporary';
END;
$$
LANGUAGE plpgsql;

CALL increase_contract();

SELECT * FROM employee WHERE contract_type = 'Temporary';
		



CREATE OR REPLACE PROCEDURE increase_salaries_decimal(percentage DECIMAL, salary_limit DECIMAL DEFAULT NULL)
AS $$
BEGIN
  IF salary_limit IS NULL OR salary_limit = 0 THEN
    salary_limit := 5000;
  END IF;
  
  UPDATE employee
  SET salary = salary * (1 + percentage)
  WHERE salary < salary_limit;
END;
$$ LANGUAGE plpgsql;

CALL increase_salaries_decimal(0.1, 1000);
