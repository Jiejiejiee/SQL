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
select uni.dept_no, uni.emp_no, max_salary.salary
from
    (select d.dept_no, s.emp_no, s.salary
     from dept_emp d join salaries s
     on d.emp_no = s.emp_no
     and d.to_date = '9999-01-01'
     and s.to_date = '9999-01-01'
    ) as uni, /* 部门编号,员工编号,当前薪水 */
    (select d.dept_no, max(s.salary) as salary
     from dept_emp d join salaries s
     on d.emp_no = s.emp_no
     and d.to_date = '9999-01-01'
     and s.to_date = '9999-01-01'
     group by d.dept_no
    ) as max_salary /* 部门编号,当前最高薪水 */
where uni.salary = max_salary.salary
and uni.dept_no = max_salary.dept_no
order by uni.dept_no;