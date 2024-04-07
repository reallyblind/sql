#第16章_变量、流程控制与游标

#1.变量
#1.1变量：系统变量（全局系统变量、会话系统变量）） vs 用户自定义变量

#1.2.查看系统变量
#查询全局系统变量
SHOW GLOBAL VARIABLES;#617
#查询会话系统变量
SHOW SESSION VARIABLES;#640

SHOW VARIABLES;#默认查询的是会话系统变量

#查询部分系统变量
SHOW GLOBAL VARIABLES LIKE 'admin_%';

SHOW VARIABLES LIKE 'character_%';


#1.3 查看指定的系统变量
SELECT @@global.max_connections;

SELECT @@global.character_set_client;

#错误：Variable 'pseudo_thread_id' is a SESSION variable
SELECT @@global.pseudo_thread_id;


#错误：Variable 'max_connections' is a GLOBAL variable
SELECT @@session.max_connections;

SELECT @@session.character_set_client;

SELECT @@session.pseudo_thread_id;

SELECT @@character_set_client;#先查询会话系统变量，再查询全局系统变量

#1.4 修改系统变量的值
#全局系统变量：
#方式1：
SET @@global.max_connections = 161;
#方式2：
SET GLOBAL max_connections = 171;

#针对于当前的数据库实例是有效的，一旦重启MySQL服务器，就失效了


#会话系统变量：
#方式1：
SET @session.character_set_client = 'gbk';
#方式2：
SET SESSION character_set_client = 'gbk';

#针对于当前会话是有效的，一旦结束会话，重新建立起新的会话，就失效了



#1.5 用户变量
/*
① 用户变量：会话用户变量 vs 局部变量

② 会话用户变量：使用“@”开头，作用域为当前会话

③ 局部变量：只能使用在存储过程和存储函数中的

*/

#1.6 会话用户变量
/*
① 变量的声明和赋值
#方式1：“=”或“:=”
SET @用户变量 = 值;
SET @用户变量 := 值;

#方式2：“:=” 或 INTO关键字
SELECT @用户变量 := 表达式 [FROM 等子句];
SELECT 表达式 INTO @用户变量 [FROM 等子句]

② 使用
SELECT @变量名

*/
#准备工作
CREATE DATABASE dbtest16;
USE dbtest16;

CREATE TABLE employees
AS
SELECT * FROM atguigudb.`employees`;

CREATE TABLE departments
AS
SELECT * FROM atguigudb.`departments`;

SELECT * FROM employees;
SELECT * FROM departments;

#测试:
#方式1：
SET @m1 = 1;
SET @m2 :=2;
SET @sum:= @m1+@m2;

SELECT @sum;

#方式2：
SELECT @count := COUNT(*) FROM employees;

SELECT @count;

SELECT AVG(salary) INTO @avg_sal FROM employees;

SELECT @avg_sal;

#1.7 局部变量
/*
1、局部变量必须 满足：
① 使用DECLARE声明 
②声明并使用在BEGIN...END中（使用在存储过程、函数中）
③DECLARE的方式声明的局部变量必须声明在BEGIN中的首行的位置

2、声明格式
DECLARE 变量名 类型 [default 值]; # 如果没有DEFAULT子句，初始值为NULL

3.赋值
 方式1：
SET 变量名=值;
SET 变量名:=值;
 方式2：
SELECT 字段名或表达式 INTO 变量名 FROM 表;

4.使用
SELECT 局部变量名;
*/

#举例：
DELIMITER //

CREATE PROCEDURE test_var()
BEGIN
	#1.声明局部变量
	DECLARE a INT DEFAULT 0;
	DECLARE b INT ;
	#DECLARE a,b int DEFAULT(25);
	DECLARE emp_name VARCHAR(25);
	
	#2.赋值
	SET a = 1;
	SET b:=2;
	
	SELECT last_name INTO emp_name FROM employees WHERE employee_id =101;
	
	#3.使用
	SELECT a,b,emp_name;
END //
DELIMITER ;

#调用存储过程
CALL test_var();


#举例1：声明局部变量，并分别赋值为employees表中employee_id为102的last_name和salary

DELIMITER //
CREATE PROCEDURE test_pro()
BEGIN
	#声明
	DECLARE emp_name VARCHAR(25);
	DECLARE sal DOUBLE(10,2) DEFAULT 0.0;
	#赋值
	SELECT last_name,salary INTO emp_name,sal
	FROM employees
	WHERE employee_id =102;
	#使用
	SELECT emp_name,sal;

END //
DELIMITER ;

#调用存储过程
CALL test_pro();

SELECT last_name,salary FROM employees
WHERE employee_id = 102;

#举例2：声明两个变量，求和并打印 （分别使用会话用户变量、局部变量的方式实现）

#方式1：使用会话用户变量
SET @v1 = 10;
SET @v2 = 20;
SET @result := @v1 +@v2;

#查看
SELECT @result;

#方式2：使用局部变量
DELIMITER //

CREATE PROCEDURE add_value()
BEGIN
	#声明
	DECLARE value1,value2 ,sum_val INT;
	
	#赋值
	SET value1 = 10;
	SET value2 :=100;
	
	SET sum_val = value1 + value2; 
	#使用
	SELECT sum_val;
	
END //
DELIMITER ;

#调用
CALL add_value();


#举例3：创建存储过程“different_salary”查询某员工和他领导的薪资差距，
#并用IN参数emp_id接收员工id，用OUT参数dif_salary输出薪资差距结果。

DELIMITER //

CREATE PROCEDURE different_salary(IN emp_id INT,OUT dif_salary DOUBLE)
BEGIN
	#分析：查询出emp_id员工的工资；查询出emp_id员工的管理者id；
	#查询管理者id的工资；计算两个工资差值
	
	#声明变量
	DECLARE emp_sal DOUBLE DEFAULT 0.0;#记录员工工资
	DECLARE mgr_sal DOUBLE DEFAULT 0.0;#记录管理者工资
	DECLARE mgr_id INT DEFAULT 0;#记录管理者的id
	
	#赋值
	SELECT salary INTO emp_sal FROM employees WHERE employee_id = emp_id;
	SELECT manager_id INTO mgr_id FROM employees WHERE employee_id = emp_id;
	SELECT salary INTO mgr_sal FROM employees WHERE employee_id = mgr_id;
	
	SET dif_salary = mgr_sal - emp_sal;
	
END //
DELIMITER ;

#调用存储过程
SET @emp_id := 102;
CALL different_salary(@emp_id,@dif_sal);

SELECT @dif_sal;



#2.定义条件与处理程序

#2.1 错误演示：

#错误代码： 1364
#Field 'email' doesn't have a default value
INSERT INTO employees(last_name)
VALUES('Tom');

DESC employees;

#错误演示：
DELIMITER //
CREATE PROCEDURE UpdateDataNoCondition()
	BEGIN
		SET @x = 1;
		UPDATE employees SET email = NULL WHERE last_name = 'Abel';
		SET @x = 2;
		UPDATE employees SET email = 'aabbel' WHERE last_name = 'Abel';
		SET @x = 3;
	END //
DELIMITER ;

#调用存储过程
#错误代码： 1048
#Column 'email' cannot be null
CALL UpdateDataNoCondition();

#2.2 定义条件

#格式：DECLARE 错误名称 CONDITION FOR 错误码（或错误条件）

#举例1：定义“Field_Not_Be_NULL”错误名与MySQL中违反非空约束的
#错误类型是“ERROR 1048 (23000)”对应。

#方式1：使用MySQL_error_code
DECLARE Field_Not_Be_NULL CONDITION FOR 1048;

#方式2：使用sqlstate_value
DECLARE Field_Not_Be_NULL CONDITION FOR SQLSTATE '23000';

#举例2：定义"ERROR 1148(42000)"错误，名称为command_not_allowed。
#方式1：使用MySQL_error_code
DECLARE command_not_allowed CONDITION FOR 1148;

#方式2：使用sqlstate_value
DECLARE command_not_allowed CONDITION FOR SQLSTATE '42000';

#2.3 定义处理程序
#格式：DECLARE 处理方式 HANDLER FOR 错误类型 处理语句

#举例：
#方法1：捕获sqlstate_value
DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02' SET @info = 'NO_SUCH_TABLE';

#方法2：捕获mysql_error_value
DECLARE CONTINUE HANDLER FOR 1146 SET @info = 'NO_SUCH_TABLE';

#方法3：先定义条件，再调用
DECLARE no_such_table CONDITION FOR 1146;
DECLARE CONTINUE HANDLER FOR NO_SUCH_TABLE SET @info = 'NO_SUCH_TABLE';

#方法4：使用SQLWARNING
DECLARE EXIT HANDLER FOR SQLWARNING SET @info = 'ERROR';

#方法5：使用NOT FOUND
DECLARE EXIT HANDLER FOR NOT FOUND SET @info = 'NO_SUCH_TABLE';

#方法6：使用SQLEXCEPTION
DECLARE EXIT HANDLER FOR SQLEXCEPTION SET @info = 'ERROR';


#2.4 案例的解决

DROP PROCEDURE UpdateDataNoCondition;

#重新定义存储过程，体现错误的处理
DELIMITER //
CREATE PROCEDURE UpdateDataNoCondition()
	BEGIN
		#声明处理程序
		#处理方式1：
		DECLARE CONTINUE HANDLER FOR 1048 SET @prc_value = -1;
		#处理方式2：
		#declare continue handler for sqlstate '23000' set @prc_value = -1;
		
		SET @x = 1;
		UPDATE employees SET email = NULL WHERE last_name = 'Abel';
		SET @x = 2;
		UPDATE employees SET email = 'aabbel' WHERE last_name = 'Abel';
		SET @x = 3;
	END //
DELIMITER ;

#调用存储过程
CALL UpdateDataNoCondition();

#查看变量
SELECT @x,@prc_value;

#2.5 再举一个例子
#创建一个名称为“InsertDataWithCondition”的存储过程。

#①准备工作
CREATE TABLE departments
AS
SELECT * FROM atguigudb.`departments`;

ALTER TABLE departments
ADD CONSTRAINT uk_dept_name UNIQUE(department_id);

DESC departments;

#②定义存储过程
DELIMITER //
	CREATE PROCEDURE InsertDataWithCondition()
		BEGIN
		SET @x = 1;
		INSERT INTO departments(department_name) VALUES('测试');
		SET @x = 2;
		INSERT INTO departments(department_name) VALUES('测试');
		SET @x = 3;
	END //
DELIMITER ;

SELECT department_id FROM departments; 

DELETE FROM departments
WHERE department_id = 0;

#调用
CALL InsertDataWithCondition();

SELECT @x,@proc_value;#2,-1

#删除此存储过程
DROP PROCEDURE InsertDataWithCondition;

#重新定义存储过程（考虑到错误的处理程序）
DELIMITER //
	CREATE PROCEDURE InsertDataWithCondition()
		BEGIN
		DECLARE duplicate_entry CONDITION FOR SQLSTATE '23000' ;
		DECLARE EXIT HANDLER FOR duplicate_entry SET @proc_value = -1;
		SET @x = 1;
		INSERT INTO departments(department_name) VALUES('测试');
		SET @x = 2;
		INSERT INTO departments(department_name) VALUES('测试');
		SET @x = 3;
	END //
DELIMITER ;

#调用
CALL InsertDataWithCondition();

SELECT @x,@proc_value;#1,-1 之前已经存在0了

#3.流程控制
#3.1 分支结构之 IF

#举例
DELIMITER //

CREATE PROCEDURE test_if()
BEGIN
	#情况1：
	#声明局部变量
	#declare stu_name varchar(15);
	#
	#if stu_name is null
	#	then select 'stu_name is null';
	#end if;
	
	#情况2：
	#declare email varchar(25);
	#if email is null
	#	then select 'email is null';
	#else 
	#	select 'email is not null';
	#end if;
	
	#情况3：
	DECLARE age INT DEFAULT 20;
	IF age > 40
		THEN SELECT '中老年';
	ELSEIF age > 18
		THEN SELECT '青壮年';
	SELECT age > 8
		THEN SELECT '青少年';
	ELSE 
		SELECT '婴幼儿';
	END IF;
END //
DELIMITER ;

#调用
CALL test_if();

DROP PROCEDURE test_if;

#举例2：声明存储过程“update_salary_by_eid1”，定义IN参数emp_id，输入员工编号。
#判断该员工薪资如果低于8000元并且入职时间超过5年，就涨薪500元；否则就不变。
DELIMITER //
CREATE PROCEDURE update_salary_by_eid1(IN emp_id INT)
BEGIN
	#声明局部变量
	DECLARE emp_sal DOUBLE;
	DECLARE hire_year DOUBLE;#记录员工入职公司的年头
	
	#赋值
	SELECT salary INTO emp_sal FROM employees WHERE employee_id = emp_id;
	SELECT DATEDIFF(CURDATE(),hire_date)/365  INTO hire_year FROM employees WHERE employee_id = emp_id;
	
	#判断
	IF emp_sal < 8000 AND hire_year >= 5
		THEN UPDATE employees SET salary = salary+5000 WHERE employee_id = emp_id;
	END IF;

END //
DELIMITER ;

DROP PROCEDURE update_salary_by_eid1;
#调用存储过程
SELECT DATEDIFF(CURDATE(),hire_date)/365,employee_id,salary
FROM employees
WHERE salary < 8000 AND DATEDIFF(CURDATE(),hire_date)/365>=5;


CALL update_salary_by_eid1(104);

SELECT * FROM employees WHERE employee_id =104;


#举例3：声明存储过程“update_salary_by_eid2”，定义IN参数emp_id，输入员工编号。
#判断该员工薪资如果低于9000元并且入职时间超过5年，就涨薪500元；否则就涨薪100元。
DELIMITER //
CREATE PROCEDURE update_salary_by_eid2(IN emp_id INT)
BEGIN
	#声明局部变量
	DECLARE emp_sal DOUBLE;
	DECLARE hire_year DOUBLE;#记录员工入职公司的年头
	
	#赋值
	SELECT salary INTO emp_sal FROM employees WHERE employee_id = emp_id;
	SELECT DATEDIFF(CURDATE(),hire_date)/365  INTO hire_year FROM employees WHERE employee_id = emp_id;
	
	#判断
	IF emp_sal < 9000 AND hire_year >= 5
		THEN UPDATE employees SET salary = salary+500 WHERE employee_id = emp_id;
	ELSE
		UPDATE employees SET salary = salary+100 WHERE employee_id = emp_id;
	END IF;

END //
DELIMITER ;

#
SELECT DATEDIFF(CURDATE(),hire_date)/365,employee_id,salary
FROM employees
WHERE salary < 9000 AND DATEDIFF(CURDATE(),hire_date)/365>=5;

SELECT * FROM employees
WHERE employee_id IN(102,103,104,105);

CALL update_salary_by_eid2(104);

SELECT * FROM employees WHERE employee_id =104;


#举例4：声明存储过程“update_salary_by_eid3”，定义IN参数emp_id，输入员工编号。
#判断该员工薪资如果低于9000元，就更新薪资为9000元；薪资如果大于等于9000元且
#低于10000的，但是奖金比例为NULL的，就更新奖金比例为0.01；其他的涨薪100元。

DELIMITER //
CREATE PROCEDURE update_salary_by_eid3(IN emp_id INT)
BEGIN
	#声明变量
	DECLARE emp_sal DOUBLE;
	DECLARE bonus DOUBLE;
	
	#赋值
	SELECT salary INTO emp_sal FROM employees WHERE employee_id = emp_id;
	SELECT commission_pct INTO bonus FROM employees WHERE employee_id = emp_id;
	
	#判断
	IF emp_sal <9000
		THEN UPDATE employees SET salary = 9000 WHERE employee_id = emp_id;
	ELSEIF emp_sal<10000 AND bonus IS NULL
		THEN UPDATE employees SET commission_pct = 0.01 WHERE employee_id = emp_id;
	ELSE UPDATE employees SET salary =salary +100 WHERE employee_id = emp_id;
	END IF;
END //
DELIMITER ;

SELECT * FROM employees;

#调用
CALL update_salary_by_eid3(102);


#3.2 分支结构之CASE

#举例
DELIMITER //
CREATE PROCEDURE test_case()
BEGIN
	DECLARE val INT;
	SET val = 1;
	 
	CASE val
		WHEN 1 THEN SELECT 'val is 1';
		WHEN 2 THEN SELECT 'val is 2';
		ELSE SELECT 'val is not 1 or 2';
	END CASE;

END //
DELIMITER ;

#调用
CALL test_case();


#4.1 循环结构之LOOP
/*
[loop_label:] LOOP
循环执行的语句
END LOOP [loop_label]
*/
#举例1：
DELIMITER //
CREATE PROCEDURE test_loop()
BEGIN
	#声明局部变量
	DECLARE id INT DEFAULT 0;
	
	add_loop:LOOP
		#重新赋值
		SET id = id +1;
		IF id >= 10 THEN LEAVE add_loop;
		END IF;
	
	
	END LOOP add_loop;
	
	#查看id
	SELECT id;
	
END //
DELIMITER ;

#调用
CALL test_case();
CALL test_loop();


#举例2：当市场环境变好时，公司为了奖励大家，决定给大家涨工资。声明存储过程
#“update_salary_loop()”，声明OUT参数num，输出循环次数。存储过程中实现循环给大家
#涨薪，薪资涨为原来的1.1倍。直到全公司的平均薪资达到12000结束。并统计循环次数。

DELIMITER //
CREATE PROCEDURE update_salary_loop(OUT num INT)
BEGIN
	#声明变量
	DECLARE avg_sal DOUBLE;#记录员工的平均工资
	
	DECLARE loop_count INT DEFAULT 0;#记录循环次数
	
	#获取员工的平均工资
	SELECT AVG(salary) INTO avg_sal FROM employees;
	
	loop_lab:LOOP
		#结束循环的条件
		IF avg_sal >=12000
			THEN LEAVE loop_lab;
		END IF;
		
		UPDATE employees SET salary = salary*1.1;
		
		#更新avg_sal变量的值
		SELECT AVG(salary) INTO avg_sal FROM employees;
		
		#记录循环次数
		SET loop_count = loop_count + 1;
	END LOOP loop_lab;
	#给num赋值
	SET num = loop_count;


END //
DELIMITER ;


SELECT AVG(salary) FROM employees;

CALL update_salary_loop(@num);

SELECT @num;


#4.2 循环结构之while
/*
[while_label:] WHILE 循环条件 DO
循环体
END WHILE [while_label]
*/



#4.3 循环结构之REPEAT
/*
[repeat_label:] REPEAT
循环体的语句
UNTIL 结束循环的条件表达式
END REPEAT [repeat_label]
*/

#举例1：

DELIMITER //
CREATE PROCEDURE test_repeat()
BEGIN
	#声明变量
	DECLARE num INT DEFAULT 1;
	REPEAT
		SET num=num+1;
		UNTIL num>=10
	END REPEAT;
	
	#查看
	SELECT num;

END //
DELIMITER ;

#调用
CALL test_repeat();


#5.1 LEAVE的使用
/*
举例1：创建存储过程 “leave_begin()”，声明INT类型的IN参数num。给BEGIN...END加标记名，并在
BEGIN...END中使用IF语句判断num参数的值。
如果num<=0，则使用LEAVE语句退出BEGIN...END；
如果num=1，则查询“employees”表的平均薪资；
如果num=2，则查询“employees”表的最低薪资；
如果num>2，则查询“employees”表的最高薪资。
IF语句结束后查询“employees”表的总人数。
*/

DELIMITER //
CREATE PROCEDURE leave_begin(IN num INT)
begin_label:BEGIN
	IF num<=0
		THEN LEAVE begin_label;
	ELSEIF num=1
		THEN SELECT AVG(salary) FROM employees;
	ELSEIF num=2
		THEN SELECT MIN(salary) FROM employees;
	ELSE 
		SELECT MAX(salary) FROM employees;
	END IF;
	
	#查询总人数
	SELECT COUNT(*) FROM employees;


END //
DELIMITER ;


#调用
CALL leave_begin(1);


#5.2 跳转语句之ITERATE语句
/*
举例： 定义局部变量num，初始值为0。循环结构中执行num + 1操作。
如果num < 10，则继续执行循环；
如果num > 15，则退出循环结构；

*/
DELIMITER //
CREATE PROCEDURE test_iterate()
BEGIN
	DECLARE num INT DEFAULT 0;
	
	loop_label:LOOP
		#赋值
		SET num = num+1;
		
		IF num<10
			THEN ITERATE loop_label;
		ELSEIF num>15
			THEN LEAVE loop_label;
		END IF;
		SELECT '尚硅谷';
	
	END LOOP loop_label;
END //
DELIMITER ;

#调用
CALL test_iterate();


#6.游标的使用
/*
游标使用的步骤：
①声明游标
②打开游标
③使用游标（从游标中获取数据）
④关闭游标
*/

#创建存储过程“get_count_by_limit_total_salary()”，声明IN参数 limit_total_salary，DOUBLE
#类型；声明OUT参数total_count，INT类型。函数的功能可以实现累加薪资最高的几个员工的薪资值，
#直到薪资总和达到limit_total_salary参数的值，返回累加的人数给total_count。


DELIMITER //
CREATE PROCEDURE get_count_by_limit_total_salary(IN limit_total_salary DOUBLE,OUT total_count INT)
BEGIN
	#声明局部变量
	DECLARE sum_sal DOUBLE DEFAULT 0.0;#记录累加的工资总和
	DECLARE emp_sal DOUBLE;#记录每一个员工的工资
	DECLARE emp_count INT DEFAULT 0;#记录累加的人数
	
	
	#声明游标
	DECLARE emp_cursor CURSOR FOR SELECT salary FROM employees ORDER BY salary DESC;
	
	#2.打开游标
	OPEN emp_cursor;
	
	REPEAT 
		
		#3.使用游标
		FETCH emp_cursor INTO emp_sal;
		
		SET sum_sal = sum_sal + emp_sal;
		SET emp_count = emp_count+1;
		UNTIL sum_sal>=limit_total_salary
	END REPEAT;
	
	SET total_count = emp_count;
	
	#4.关闭游标
	CLOSE emp_cursor;
	
END //
DELIMITER ;

DROP PROCEDURE get_count_by_limit_total_salary

#调用
CALL get_count_by_limit_total_salary(200000,@total_count);
SELECT @total_count;










