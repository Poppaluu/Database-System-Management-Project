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
		



CREATE OR REPLACE PROCEDURE increase_salaries_decimal(percentage DECIMAL)
AS $$
BEGIN
  UPDATE employee
  SET salary = salary * (1 + percentage)
  WHERE salary < 5000;
END;
$$ LANGUAGE plpgsql;

CALL increase_salaries_decimal(0.1);

SELECT * FROM employee WHERE salary < 5000;



CREATE OR REPLACE PROCEDURE increase_salaries_integer(percentage INTEGER)
AS $$
BEGIN
  UPDATE employee
  SET salary = salary + (salary * percentage / 100)
  WHERE salary < 5000;
END;
$$ LANGUAGE plpgsql;

CALL increase_salaries_integer(10);

SELECT * FROM employee;

	