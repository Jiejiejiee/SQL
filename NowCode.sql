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
from (select d.dept_no, s.emp_no, s.salary
      from dept_emp d
               join salaries s
                    on d.emp_no = s.emp_no
                        and d.to_date = '9999-01-01'
                        and s.to_date = '9999-01-01') as uni, /* 部门编号,员工编号,当前薪水 */
     (select d.dept_no, max(s.salary) as salary
      from dept_emp d
               join salaries s
                    on d.emp_no = s.emp_no
                        and d.to_date = '9999-01-01'
                        and s.to_date = '9999-01-01'
      group by d.dept_no) as max_salary /* 部门编号,当前最高薪水 */
where uni.salary = max_salary.salary
  and uni.dept_no = max_salary.dept_no
order by uni.dept_no;

-- 205
select a.emp_no, b.emp_no
from dept_emp a
         left join dept_manager b
                   on a.dept_no = b.dept_no
where a.emp_no not in (select emp_no from dept_manager);

-- 210
select title, avg(s.salary)
from titles t
         left join salaries s
                   on t.emp_no = s.emp_no
group by title;

-- 218
select de.dept_no, e.emp_no, salary
from employees e
         left join dept_emp de
                   on e.emp_no = de.emp_no
    -- left join dept_manager dm
    -- on de.dept_no = dm.dept_no
         left join salaries s
                   on e.emp_no = s.emp_no
where e.emp_no not in (select emp_no from dept_manager);

-- 217
select emp_no, salary, rank() over (order by salary desc ) as value
from salaries;
-- 如果salary相同，再按照emp_no升序排列
select emp_no, salary, dense_rank() over (order by salary desc ) as value
from salaries
order by salary desc, emp_no;

-- 215
select s1.emp_no, (s2.salary - s1.salary) as growth
from salaries s1
         left join salaries s2
                   on s1.to_date = s2.from_date
         left join employees
                   on s1.emp_no = employees.emp_no
where s2.emp_no is not null
  and (s2.salary - s1.salary) IS NOT NULL;
-- 存在问题，若一个员工有多条记录，输出结果无法整合
select b.emp_no, (b.salary - a.salary) as growth
from (select e.emp_no, s.salary
      from employees e
               left join salaries s
                         on e.emp_no = s.emp_no
                             and e.hire_date = s.from_date) a -- 入职工资表
         inner join
     (select e.emp_no, s.salary
      from employees e
               left join salaries s
                         on e.emp_no = s.emp_no
      where s.to_date = '9999-01-01') b -- 现在工资表
     on a.emp_no = b.emp_no
order by growth;

-- 