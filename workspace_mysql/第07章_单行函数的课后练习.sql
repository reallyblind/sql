#第07章_单行函数的课后练习

# 1.显示系统时间(注：日期+时间)
SELECT NOW()
FROM DUAL;

# 2.查询员工号，姓名，工资，以及工资提高百分之20%后的结果（new salary）
SELECT employee_id,last_name,salary,salary*(1.2) AS "new salary"
FROM employees;


# 3.将员工的姓名按首字母排序，并写出姓名的长度（length）
SELECT last_name,LENGTH(last_name) "length"
FROM employees
ORDER BY last_name ASC;


# 4.查询员工id,last_name,salary，并作为一个列输出，别名为OUT_PUT
SELECT CONCAT(employee_id,',',last_name,',',salary) "OUT_PUT"
FROM employees;


# 5.查询公司各员工工作的年数、工作的天数，并按工作年数的降序排序
SELECT employee_id,
#datediff(curdate(),hire_date)/365 "worked_years"
TO_DAYS(CURDATE())-
FROM employees


# 6.查询员工姓名，hire_date , department_id，满足以下条件：雇用时间在1997年之后，department_id
#为80 或 90 或110, commission_pct不为空
SELECT last_name,department_id,hire_date
FROM employees
WHERE department_id IN(80,90,100)
AND commission_pct IS NOT NULL
#and hire_date >='1997-01-01'; #存在着隐式转换
AND DATE_FORMAT(hire_date,'%Y-%m-%d')>='1997-01-01';   #显示转换操作：格式化：日期-->字符串



# 7.查询公司中入职超过10000天的员工姓名、入职时间
SELECT last_name,hire_date
FROM employees
WHERE DATEDIFF(CURDATE(),hire_date)>=10000;


# 8.做一个查询，产生下面的结果
#<last_name> earns <salary> monthly but wants <salary*3>
SELECT CONCAT(last_name,'earns',TRUNCATE(salary,0),' monthly but wants ',TRUNCATE(salary*3,0) )
FROM employees;


