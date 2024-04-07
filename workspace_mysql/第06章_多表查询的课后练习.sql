# 第06章_多表查询的课后练习

# 1.显示所有员工的姓名，部门号和部门名称。
SELECT last_name,e.department_id,department_name
FROM employees e LEFT OUTER JOIN departments d
ON e.`department_id` = d.`department_id`;

# 2.查询90号部门员工的job_id和90号部门的location_id
SELECT job_id,location_id
FROM employees e,departments d
WHERE e.`department_id`=d.`department_id`
AND e.`department_id`=90;
# 3.选择所有有奖金的员工的 last_name , department_name , location_id , city
SELECT last_name , department_name , d.location_id , city
FROM employees e
	LEFT OUTER JOIN departments d
	ON e.`department_id`=d.`department_id`
		LEFT OUTER JOIN locations l
		ON d.`location_id`=l.`location_id`
WHERE commission_pct IS NOT NULL;


# 4.选择city在Toronto工作的员工的 last_name , job_id , department_id , department_name
SELECT last_name , job_id , e.department_id , department_name
FROM employees e
	LEFT OUTER JOIN departments d
	ON e.`department_id`=d.`department_id`
		LEFT OUTER JOIN locations l
		ON d.`location_id`=l.`location_id`
WHERE city = 'toronto';

# 5.查询员工所在的部门名称、部门地址、姓名、工作、工资，其中员工所在部门的部门名称为’Executive’
SELECT department_name, street_address, last_name, job_id, salary 
FROM employees 
	LEFT OUTER JOIN departments d
	ON e.`department_id`=d.`department_id`
		LEFT OUTER JOIN locations l
		ON d.`location_id`=l.`location_id`
WHERE department_name = 'Executive';


# 6.选择指定员工的姓名，员工号，以及他的管理者的姓名和员工号，结果类似于下面的格式
employees Emp# manager Mgr#
kochhar 101 king 100

SELECT emp.last_name employees, emp.employee_id "Emp#", mgr.last_name manager,mgr.employee_id "Mgr#"
FROM employees emp
	LEFT OUTER JOIN employees mgr
	ON emp.manager_id = mgr.manager_id;

# 7.查询哪些部门没有员工
SELECT d.department_id,e.`department_id`
FROM departments d
	LEFT OUTER JOIN employees e
	ON e.`department_id`=d.`department_id`
WHERE e.`department_id` IS NULL;

# 8. 查询哪个城市没有部门
SELECT l.location_id,city
FROM locations l
	LEFT OUTER JOIN departments d
	ON l.`location_id`=d.`location_id`
WHERE d.`location_id` IS NULL;


# 9. 查询部门名为 Sales 或 IT 的员工信息
SELECT employee_id,last_name,department_name
FROM employees e,departments d
WHERE e.`department_id`=d.`department_id`
AND d.`department_name` IN('Sales','IT');
