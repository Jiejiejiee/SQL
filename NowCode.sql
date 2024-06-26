-- 205
select a.emp_no, b.emp_no
from dept_emp a
         left join dept_manager b
                   on a.dept_no = b.dept_no
where a.emp_no not in (select emp_no from dept_manager);


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


-- 210
select title, avg(s.salary)
from titles t
         left join salaries s
                   on t.emp_no = s.emp_no
group by title;


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


-- 217
select emp_no, salary, rank() over (order by salary desc ) as value
from salaries;
-- 如果salary相同，再按照emp_no升序排列
select emp_no, salary, dense_rank() over (order by salary desc ) as value
from salaries
order by salary desc, emp_no;


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


-- 219
-- 三个表通过左连接无法查询manager的salary，需要再次左连接一张salaries查询manager的salary
select de.emp_no as emp_no, dm.emp_no as manager_no, s1.salary as emp_salary, s2.salary as manager_salary
from dept_emp de
         left join salaries s1
                   on de.emp_no = s1.emp_no
                       and s1.to_date = '9999-01-01'
                       and de.to_date = '9999-01-01'
         left join dept_manager dm
                   on de.dept_no = dm.dept_no
                       and dm.to_date = '9999-01-01'
         left join salaries s2
                   on dm.emp_no = s2.emp_no
                       and s2.to_date = '9999-01-01'
where de.emp_no <> dm.emp_no
  and s1.salary > s2.salary;

-- 通过查询employee和Manager的工资，再将两张子表连接查询
select *
from dept_emp de
         left join salaries s
                   on de.emp_no = s.emp_no
where s.to_date = '9999-01-01';

select *
from dept_manager dm
         left join salaries s
                   on dm.emp_no = s.emp_no
where s.to_date = '9999-01-01';

select a.emp_no as emp_no, b.emp_no as manager_no, a.salary as emp_salary, b.salary as manager_salary
from (select de.emp_no, salary, dept_no
      from dept_emp de
               left join salaries s
                         on de.emp_no = s.emp_no
      where de.to_date = '9999-01-01'
        and s.to_date = '9999-01-01') a
         inner join (select dm.emp_no, salary, dept_no
                     from dept_manager dm
                              left join salaries s
                                        on dm.emp_no = s.emp_no
                     where dm.to_date = '9999-01-01'
                       and s.to_date = '9999-01-01') b
                    on a.dept_no = b.dept_no
where a.emp_no <> b.emp_no
  and a.salary > b.salary;


-- 220
select de.dept_no, d.dept_name, t.title, count(title)
from dept_emp de
         left join titles t
                   on de.emp_no = t.emp_no
         left join departments d
                   on de.dept_no = d.dept_no
group by de.dept_no, d.dept_name, t.title
order by dept_no, title;

-- 253
-- Todo:left join 出现数据丢失的情况
select e.emp_no,
       e.first_name,
       e.last_name,
       btype,
       salary,
       case
           when btype = 1 then salary * 0.1
           when btype = 2 then salary * 0.2
           else salary * 0.3 end as bonus
from employees e
         inner join emp_bonus
                    on emp_bonus.emp_no = e.emp_no
         inner join salaries
                    on salaries.emp_no = e.emp_no
where to_date = '9999-01-01'
order by emp_no;

-- 260
-- 改写法会触发sql_mode=only_full_group_by报错，
# select user_id, date
# from login
# group by user_id
# order by date desc
# limit 1;
select user_id, max(date) as id
from login
group by user_id
order by user_id;
