
CREATE SEQUENCE employeeMock_e_id_seq;
CREATE TABLE IF NOT EXISTS public.employeeMock
(
    e_id integer NOT NULL DEFAULT nextval('employeeMock_e_id_seq'::regclass),
    emp_name character varying COLLATE pg_catalog."default" DEFAULT 'No Name'::character varying,
    email character varying COLLATE pg_catalog."default",
    contract_type character varying COLLATE pg_catalog."default" NOT NULL,
    contract_start date NOT NULL,
    contract_end date,
    salary integer DEFAULT 0,
    supervisor integer,
    d_id integer,
    j_id integer,
    CONSTRAINT employeeMock_pkey PRIMARY KEY (e_id),
    CONSTRAINT employeeMock_d_id_fkey FOREIGN KEY (d_id)
        REFERENCES public.department (d_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT employeeMock_j_id_fkey FOREIGN KEY (j_id)
        REFERENCES public.job_title (j_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT employeeMock_supervisor_fkey FOREIGN KEY (supervisor)
        REFERENCES public.employeeMock (e_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
) PARTITION BY HASH(e_id);

CREATE TABLE employee_hash_1
PARTITION OF employeeMock
FOR VALUES WITH (modulus 3, remainder 0);
 
CREATE TABLE employee_hash_2
PARTITION OF employeeMock
FOR VALUES WITH (modulus 3, remainder 1);
 
CREATE TABLE employee_hash_3
PARTITION OF employeeMock
FOR VALUES WITH (modulus 3, remainder 2);


ALTER TABLE IF EXISTS public.employeeMock
    OWNER to postgres;
GRANT SELECT(e_id) ON public.employeeMock TO trainee;
GRANT SELECT(emp_name) ON public.employeeMock TO trainee;
GRANT SELECT(email) ON public.employeeMock TO trainee;

CREATE TRIGGER temporary_contract_trigger
    BEFORE UPDATE 
    ON public.employeeMock
    FOR EACH ROW
    WHEN (old.contract_type::text <> new.contract_type::text OR old.contract_start <> new.contract_start OR old.contract_end <> new.contract_end)
    EXECUTE FUNCTION public.contract_temporary_date_check();
	
INSERT INTO employeeMock
SELECT * FROM employee;


SELECT * FROM employee_hash_3 ORDER BY e_id ASC;

SELECT * FROM employeeMock ORDER BY e_id ASC;
SELECT * FROM employee ORDER BY e_id ASC;

SELECT * FROM employee
EXCEPT
SELECT * FROM employeeMock;

SELECT * FROM employeeMock
EXCEPT
SELECT * FROM employee;
