#第08章_聚合函数


#1.3 COUNT：
#① 作用：计算指定字段在查询结构中出现的个数(不包含NULL值的)
SELECT COUNT(employee_id),COUNT(salary),COUNT(2*salary),COUNT(1),COUNT(2),COUNT(*)
FROM employees;


SELECT * ,1
FROM employees;

#如果计算表中有多少条记录，如何实现？
#方式1：count(*)
#方式2：count(1)
#方式3：count(具体字段)：不一定对！

#②注意：计算指定字段出现的个数时，是不计算null值的
SELECT COUNT(commission_pct)
FROM employees;

#③公式：AVG = SUM / COUNT
SELECT AVG(salary),SUM(salary)/COUNT(salary),
AVG(commission_pct),SUM(commission_pct)/COUNT(commission_pct) 'avg',
SUM(commission_pct)/107
FROM employees;


#需求：查询公司中平均奖金率
#错误的
SELECT AVG(commission_pct)
FROM employees;

#正确的
SELECT SUM(commission_pct)/COUNT(IFNULL(commission_pct,0)),
AVG(IFNULL(commission_pct,0))
FROM employees;

#如果需要统计表中的记录数，使用COUNT(*),COUNT(1),COUNT(具体字段)那个效率高
#如果使用的是MyISAM存储引擎，则三者效率相同，都是0(1)
#如果使用的是InnoDB引擎，则三者效率：COUNT(*)=COUNT(1)>COUNT(字段)


#2. GROUP BY的使用

#需求：查询各个部门的平均工资，最高工资
SELECT department_id,AVG(salary),SUM(salary)
FROM employees
GROUP BY department_id;

#需求：查询各个job_id的平均工资
SELECT job_id,AVG(salary)
FROM employees
GROUP BY job_id;

#需求：查询各个department_id,job_id的平均工资
#方式一：
SELECT AVG(salary),department_id,job_id
FROM employees
GROUP BY department_id,job_id;
#方式二：
SELECT AVG(salary),department_id,job_id
FROM employees
GROUP BY job_id,department_id;

#错误的
SELECT department_id,job_id,AVG(salary)
FROM employees
GROUP BY department_id;

#结论1：SELECT中出现的非主函数的字段必须声明在GROUP BY中。
#	反之，GROUP BY中声明的字段可以不出现在SELECT中

#结论2：GROUP BY 声明在FROM、WHERE后面、ORDER BY、LIMIT前面

#结论3：MySQL中 GROUP BY中使用WITH ROLLUP
SELECT department_id,AVG(salary)
FROM employees
GROUP BY department_id WITH ROLLUP;

#需求：查询各个部门的平均工资，按照平均工资升序排序
SELECT department_id,AVG(salary) avg_sal
FROM employees
GROUP BY department_id
ORDER BY avg_sal ASC;

#说明：当使用ROLLUP时，不能同时使用ORDER BY子句进行结果排序，即ROLLUP和ORDER BY是互相排斥的。
#错误的：
SELECT department_id,AVG(salary)
FROM employees
GROUP BY department_id WITH ROLLUP
ORDER BY avg_sal ASC;

#3.HAVING的使用(作用：用来过滤数据的)
#练习：查询各个部门中最高工资比10000高的部门信息
#错误的写法：
SELECT department_id,MAX(salary)
FROM employees
WHERE MAX(salary)>10000
GROUP BY department_id;

#要求1：如果过滤条件中使用了聚合函数，必须使用HAVING来替换WHERE，否则，报错
#要求2：HAVING必须声明在GROUP BY 的后面

#正确的写法：
SELECT department_id,MAX(salary)
FROM employees
GROUP BY department_id
HAVING MAX(salary)>10000;

#要求3：开发中，我们使用HAVING的前提是SQL中使用了GROUP BY

SELECT MAX(salary)
FROM employees
#HAVING MAX(salary)>10000;

#练习：查询部门id为10，20，30，40中最高工资比10000高的部门信息
#方式1：推荐使用，执行效率高于方式2
SELECT department_id,MAX(salary)
FROM employees
WHERE department_id IN(10,20,30,40)
GROUP BY department_id
HAVING MAX(salary)>10000;

#方式2：
SELECT department_id,MAX(salary)
FROM employees
GROUP BY department_id
HAVING MAX(salary)>10000 AND department_id IN(10,20,30,40);

#结论：当过滤条件中有聚合函数时，则此过滤条件必须声明在HAVING中
#	当过滤条件中没有聚合函数时，则此过滤条件声明在WHERE中或
#	HAVING中都可以。但是，建议大家声明在WHERE中
/*
  WHERE与HAVING的对比：
 1.从适用范围来讲，HAVING的适用范围更广
 2.如果过滤条件没有聚合函数，这种情况下，WHERE执行效率要高于HAVING
 
*/




#4.SQL底层执行原理
#4.1 SELECT 语句的完整结构
/*
#SQL92语法
SELECT ....,....（存在聚合函数）
FROM ...,...,
WHERE 多表的连接条件 AND 不存在聚合函数的过滤条件
GROUP BY...，...
HAVING 包含聚合函数的过滤条件
ORDER BY ...,...(ASC / DESC)
LIMIT ...,...

#SQL99语法
SELECT ....,....（存在聚合函数）
FROM ... （LEFT/RIGHT）JOIN ... ON 多表的连接条件
（LEFT/RIGHT）JOIN ... ON 多表的连接条件
WHERE 不存在聚合函数的过滤条件
GROUP BY...，...
HAVING 包含聚合函数的过滤条件
ORDER BY ...,...(ASC / DESC)
LIMIT ...,...

*/

#4.2 SQL语句的执行过程：
#FROM ...,... -> ON -> (LEFT/RIGHT JOIN) -> WHERE -> GROUP BY -> HAVING ->SELECT ->DISTINCT
# ->ORDER BY -> LIMIT




