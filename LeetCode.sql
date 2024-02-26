-- 175
select p.firstName, p.lastName, a.city, a.state
from Person p
         left join Address a
                   on a.personId = p.personId;

-- 181
select a.name as Employee
from Employee a
         left join Employee b
                   on a.managerId = b.id
where a.salary > b.salary;

-- 182
select email
from Person
group by email
having count(id) <> 0;