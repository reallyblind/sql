#第11章_数据处理之增删改

USE atguigudb;

#1.插入数据


#方法1:values的方式添加(使用这种语法一次只能向表中插入一条数据)

#情况1:为表的所有字段按默认顺序插入数据
INSERT INTO departments
VALUES(70,'Pub',100,1700);


DESC departments;

INSERT INTO departments
VALUES (1000, 'Pub', 100, 1700);

SELECT *
FROM departments;

INSERT INTO departments
VALUES (100,'finance',NULL,NULL);

DESC departments;

#情况2:为表的指定字段插入数据(推荐)
INSERT INTO departments(department_id, department_name)
VALUES (80, 'IT');

#情况3：同时插入多条记录


/*一个同时插入多行记录的INSERT语句等同于多个单行插入的INSERT语句，但是多行的INSERT语句
在处理过程中 效率更高 。因为MySQL执行单条INSERT语句插入多行数据比使用多条INSERT语句
快，所以在插入多条记录时最好选择使用 单条INSERT语句的方式插入。
*/

CREATE TABLE emp1
AS 
SELECT *
FROM employees;

CREATE TABLE emp2
AS
SELECT *
FROM employees
WHERE 1=2;

DESC emp2;
SELECT *
FROM emp2;

INSERT INTO emp2
SELECT *
FROM employees
WHERE department_id=90;


DROP TABLE emp2;
CREATE TABLE sales_reps
AS
SELECT *
FROM employees
WHERE 1=2;

SELECT *
FROM sales_reps;


INSERT INTO sales_reps(`name`,salary,commission_pct)
#查询语句
SELECT last_name,salary,commission_pct #查询的字段一定要与添加到表的字段一一对应
FROM employees
WHERE job_id LIKE '%REP%';

#说明:emp1表中要添加的字段的长度不能低于employees表中查询的字段的长度
# 如果emp1表中要添加数据的字段的长度低于employees表中查询的字段的长度的话,就有添加不成功的风险

#2.更新数据
#UPDATE ... SET ...WHERE
#可以实现批量修改数据的
UPDATE emp1
SET hire_date = CURDATE()
WHERE id = 100;

SELECT *
FROM emp1;

ALTER TABLE emp1
CHANGE employee_id id INT;

#同时修改一条数据的多个字段
UPDATE emp1
SET hire_date = CURDATE(),salary = 6000
WHERE id =100;

#题目:将表中姓名中包含字符a的提薪20%
UPDATE emp1
SET salary = salary*1.2
WHERE last_name LIKE '%a%';

#修改数据时,是可能存在不成功的情况的(可能是由于约束的影响造成的)
UPDATE employees
SET department_id = 10000
WHERE employee_id = 102;

#3.删除数据 DELECT FROM ... WHERE
DELETE FROM emp1
WHERE id = 100;
#在删除数据时,也有可能因为约束的影响,导致删除失败
DELETE FROM departments
WHERE department_id=50;

#小结:DML操作默认情况下,执行完以后都会自动提交数据
# 如果希望执行完以后不自动提交数据,则需要使用SET autocommit = FALSE;



#4.MySQL8的新特性:计算列
USE atguigudb;

CREATE TABLE test1(
a INT,
b INT,
c INT GENERATED ALWAYS AS (a+b) VIRTUAL #字段c即为计算列
);

INSERT INTO test1(a,b)
VALUES(10,20);

SELECT *
FROM test1;

UPDATE test1
SET a = 100;


#5.综合案例
# 1、创建数据库test01_library
CREATE DATABASE IF NOT EXISTS test01_library;

USE test01_library;

# 2、创建表 books，表结构如下：
CREATE TABLE books(
id INT,
NAME VARCHAR(50),
AUTHORS VARCHAR(100),
price FLOAT,
pubdate YEAR,
note VARCHAR(100),
num INT
);

# 3、向books表中插入记录
# 1）不指定字段名称，插入第一条记录
# 2）指定所有字段名称，插入第二记录
# 3）同时插入多条记录（剩下的所有记录）
INSERT INTO books
VALUES (1,'Tal of AAA ','Dickes',23,1995,'novel',11);

INSERT INTO books(id,`name`,`authors`,price,pubdate,note,num)
VALUES(2,'EmmaT','Jane lura',35,1993, 'joke',22);

INSERT INTO books (id,NAME,`authors`,price,pubdate,note,num) VALUES
(3,'Story of Jane','Jane Tim',40,2001,'novel',0),
(4,'Lovey Day','George Byron',20,2005,'novel',30),
(5,'Old land','Honore Blade',30,2010,'Law',0),
(6,'The Battle','Upton Sara',30,1999,'medicine',40),
(7,'Rose Hood','Richard haggard',28,2008,'cartoon',28);

# 4、将小说类型(novel)的书的价格都增加5。
UPDATE books
SET price = price+5
WHERE note = 'novel';

# 5、将名称为EmmaT的书的价格改为40，并将说明改为drama。
UPDATE books
SET price = 40,note='drama'
WHERE NAME='EmmaT';

# 6、删除库存为0的记录。
DELETE FROM books WHERE num = 0;

# 7、统计书名中包含a字母的书
SELECT *
FROM books
WHERE NAME LIKE '%a%';
# 8、统计书名中包含a字母的书的数量和库存总量
SELECT COUNT(*),SUM(num)
FROM books
WHERE NAME LIKE '%a%';

# 9、找出“novel”类型的书，按照价格降序排列
SELECT *
FROM books
WHERE note = 'novel'
ORDER BY price DESC;

# 10、查询图书信息，按照库存量降序排列，如果库存量相同的按照note升序排列
SELECT *
FROM books
ORDER BY num DESC,note ASC;
# 11、按照note分类统计书的数量
SELECT note,SUM(num),COUNT(*)
FROM books
GROUP BY note;


# 12、按照note分类统计书的库存量，显示库存量超过30本的
SELECT note,SUM(num)
FROM books
GROUP BY note
HAVING SUM(num)>30;

# 13、查询所有图书，每页显示5本，显示第二页
SELECT *
FROM books
LIMIT 5,5;

# 14、按照note分类统计书的库存量，显示库存量最多的
SELECT note,SUM(num)
FROM books
GROUP BY note
ORDER BY SUM(num) DESC
LIMIT 0,1


# 15、查询书名达到10个字符的书，不包括里面的空格
SELECT *
FROM books
WHERE CHAR_LENGTH(REPLACE(NAME,' ',''))>10;

# 16、查询书名和类型，其中note值为novel显示小说，law显示法律，medicine显示医药，cartoon显示卡通，
#joke显示笑话
SELECT NAME AS "书名",note,
CASE note
WHEN 'novel' THEN '小说'
WHEN 'law' THEN '法律'
WHEN 'medicine' THEN '医药'
WHEN 'cartoon' THEN '卡通'
WHEN 'joke' THEN '笑话'
END AS "类型"
FROM books

# 17、查询书名、库存，其中num值超过30本的，显示滞销，大于0并低于10的，显示畅销，为0的显示需要无货
SELECT NAME,num,CASE
WHEN num>30 THEN '滞销'
WHEN num>0 AND num<10 THEN '畅销'
WHEN num=0 THEN '无货'
ELSE '正常'
END AS "库存状态"
FROM books;


# 18、统计每一种note的库存量，并合计总量
SELECT IFNULL(note,'合计库存总数') AS note,SUM(num)
FROM books
GROUP BY note WITH ROLLUP;

# 19、统计每一种note的数量，并合计总量
SELECT IFNULL(note,'合计总量') AS note,COUNT(*)
FROM books
GROUP BY note WITH ROLLUP;

# 20、统计库存量前三名的图书
SELECT *
FROM books
ORDER BY num DESC
LIMIT 3;

# 21、找出最早出版的一本书
SELECT *
FROM books
ORDER BY pubdate ASC
LIMIT 1;

# 22、找出novel中价格最高的一本书
SELECT *
FROM books
WHERE note = 'novel'
ORDER BY price DESC
LIMIT 1;

# 23、找出书名中字数最多的一本书，不含空格
SELECT *
FROM books
ORDER BY CHAR_LENGTH(REPLACE(NAME,' ','')) DESC
LIMIT 1;

SELECT *
FROM books