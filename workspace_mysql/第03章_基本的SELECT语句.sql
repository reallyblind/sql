#第03章_基本的SELECT语句

#1.SQL的分类
/*
DDL:数据定义语言。CREATE\ALTER\DROP\RENAME\TRUNCATE


DML:数据操控语言。INSERT\DELECT\UPDATE\SELECT


DCL:数据控制语言。COMMIT\ROLLBACK\SAVEPOINT\GRANT\REVOKE

*/
USE dbtest1;

SELECT * FROM employees;

INSERT INTO employees VALUES(1002,'Tom');

SELECT * FROM employees;


SELECT employee_id,last_name,salary
FROM employees;

#6.列的别名
# as:全称:alias(别名),可以省略
#列的别名可以使用一对""引起来，不要使用''
SELECT employee_id AS emp_id,last_name AS lname,department_id
FROM employees;

#7.去除重复行
#查询员工表中一共有哪些部门？
SELECT DISTINCT department_id
FROM employees;

#错误的:
SELECT salary,DISTINCT department_id
FROM employees;
# 仅仅是没有报错，但没有实际意义
SELECT DISTINCT department_id,salary
FROM employees;

#8.空值参与运算
# 8.1.空值:null
# 8.2.null不等同于0,'','null'
SELECT * FROM employees;

# 8.3.空值参与运算:结果一定也为空
SELECT employee_id,salary "月工资",salary*(1+commission_pct)*12 "年工资",commission_pct
FROM employees;

#9.着重号``
SELECT * FROM `order`;

#10.查询常数
SELECT '尚硅谷',123,employee_id,last_name
FROM employees;

#11.显示表结构
DESCRIBE employees;#显示了表中字段的详细信息

DESC employees;

DESC departments;

#12.过滤数据

#查询90号部门的员工信息
SELECT *
FROM employees
#过滤条件,声明在FROM结构的后面
WHERE department_id =90;

#练习：查询last_name为"king"的员工信息
SELECT *
FROM employees
WHERE last_name = 'king';



