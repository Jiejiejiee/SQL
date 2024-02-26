-- 212
select max(salary) secondary_salary
from salaries
where salary != (select max(salary) max_salary from salaries);

select b.emp_no,
       b.salary,
       a.last_name,
       a.first_name
from employees a
         inner join
     salaries b on a.emp_no = b.emp_no
where b.salary in (select max(salary) max_ssecondary_salaryalary_2
                   from salaries
                   where salary != (select max(salary) max_salary from salaries));

-- 206