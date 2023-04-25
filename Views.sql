/*
Views:
employee + department + employee_skills/job_title --> project needs someone with certain skills ---> easy to find
employee + skills --> with these we can get the total salary that must be paid to an employee
customer + project + project_role + employee --> you can check who is working on what projects.
geo_location + department + employee --> with this view we can easily know from which country everyone is.
*/

DROP VIEW IF EXISTS skill_search;
CREATE OR REPLACE VIEW skill_search AS
SELECT dep_name AS department, emp_name AS name, email, string_agg(skill, ', ') AS skills
FROM department
JOIN employee ON department.d_id = employee.d_id
JOIN employee_skills ON employee.e_id = employee_skills.e_id
JOIN skills ON employee_skills.s_id = skills.s_id
GROUP BY department, name, email;

--example query for view above
SELECT * 
FROM skill_search
WHERE skills LIKE '%SQL%'
ORDER BY name;


--This is a little dangerous view and should be behind a login wall for only those that actually need it
--I'm not sure if there is use for this view since you probably have a different program for calculating salaries
--If you don't have such a program this is a great view :D
DROP VIEW IF EXISTS total_salary;
CREATE OR REPLACE VIEW total_salary AS
SELECT emp_name AS name,title, base_salary as salary, salary_benefit_value, base_salary+salary_benefit_value AS total
FROM employee
JOIN employee_skills ON employee.e_id = employee_skills.e_id
JOIN skills ON employee_skills.s_id = skills.s_id
JOIN job_title ON employee.j_id = job_title.j_id
GROUP BY name, salary, salary_benefit_value, title, base_salary;
SELECT *
FROM total_salary;


--This view allows you to check on who is working on which projects
DROP VIEW IF EXISTS project_members;
CREATE OR REPLACE VIEW project_members AS
SELECT c_name AS company, customer.email AS company_email, project_name, string_agg(emp_name, ', ') AS employees
FROM customer
JOIN project ON customer.c_id = project.c_id
JOIN project_role ON project.p_id = project_role.p_id
JOIN employee ON project_role.e_id = employee.e_id
GROUP BY company, company_email, project_name;

SELECT * FROM project_members;


/*
checking if my query is correct

I made a little python program that checks the amount of different project names
that have been got from the query below. I guess you could have done it with COUNT()
in sql but I am better at python than what I am with sql
python code:
tiedosto = open("projektit.txt", "r")
lista = []
for rivi in tiedosto:
    if rivi.strip() not in lista:
        lista.append(rivi.strip())
print(len(lista))
print(lista)

I got nine different projects and that seems to be correct

I got confused about my project_members view because when I checked the project table it had like 100 different projects
but my above view only got 9 projects. My guess now is that only projects that are active have actually workers so 
we cannot check older projects employees only current ones.
*/
DROP VIEW IF EXISTS project_members_test;
CREATE OR REPLACE VIEW project_members_test AS
SELECT c_name AS company, customer.email AS company_email, project_name, e_id
FROM customer
JOIN project ON customer.c_id = project.c_id
JOIN project_role ON project.p_id = project_role.p_id
GROUP BY company, company_email, project_name, e_id;

SELECT * FROM project_members_test;


DROP VIEW IF EXISTS employee_country;
CREATE OR REPLACE VIEW employee_country AS
SELECT country, city, hq_name AS headquarters, dep_name AS department, emp_name AS employee, email, supervisor
FROM geo_location
JOIN headquarters ON geo_location.l_id = headquarters.l_id
JOIN department ON headquarters.h_id = department.hid
JOIN employee ON department.d_id = employee.d_id
GROUP BY country, city, hq_name, dep_name, emp_name, email, supervisor;

SELECT * FROM employee_country;