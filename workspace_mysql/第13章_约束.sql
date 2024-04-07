#第13章_约束

/*
1.基础知识
1.1 为什么需要约束?为了数据的完整性

1.2 什么叫约束?对表中字段的限制

1.3 约束的分类:

角度1:约束的字段的个数
 单列约束 vs 多列约束
 

角度2:约束的作用范围
 列级约束:将此约束声明在对应字段的后面
 表记约束:在表中所有字段都声明完以后,在所有字段的后面声明的约束

角度3:约束的作用(功能)
 ①not null(非空约束)
 ②unique(唯一性约束)
 ③primary key(主键约束)
 ④foreign key(外键约束)
 ⑤check(检查约束)
 ⑥default(默认值约束)


1.4 如何添加约束?

CREATE TABLE时添加约束

ALTER TABLE 时增加或删除约束

*/

#2.如何查看表中的约束
SELECT * FROM information_schema.`TABLE_CONSTRAINTS`
WHERE table_name = 'employees';

CREATE DATABASE dbtest13;
USE dbtest13;

#3.not null(非空约束)
#3.1 在CREATE TABLE时添加约束
CREATE TABLE test1(
id INT NOT NULL,
last_name VARCHAR(15) NOT NULL,
email VARCHAR(25),
salary DECIMAL(10,2)

);

DESC test1;

INSERT INTO test1
VALUES(1,'Tom','tom@126.com',3400);

#错误:Column 'last_name' cannot be null
INSERT INTO test1
VALUES(2,NULL,'tom@126.com',3400);

INSERT INTO test1
VALUES(NULL,'Jerry','jerry@126.com',3400);

INSERT INTO test1(id,email)
VALUES(2,'abc@126.com');

UPDATE test1
SET email=NULL
WHERE id=1;

#Column 'last_name' cannot be null

UPDATE test1
SET last_name=NULL
WHERE id=1;

UPDATE test1
SET email = 'tom@126.com'
WHERE id=1;

#3.2 在ALTER TABLE时添加约束
SELECT * FROM test1;

DESC test1;

ALTER TABLE test1
MODIFY email VARCHAR(25) NOT NULL;

#3.3 在ALTER TABLE时删除约束
ALTER TABLE test1
MODIFY email VARCHAR(25) NULL;


#4. unique (唯一性约束)(null可以多次添加)

#4.1 在CREATE TABLE时添加约束
CREATE TABLE test2(
id INT UNIQUE,#列级约束
last_name VARCHAR(15) ,
email VARCHAR(25),
salary DECIMAL(10,2) ,

#表级约束
CONSTRAINT un_test2_email UNIQUE(email)

);

DESC test2;

SELECT * FROM information_schema.`TABLE_CONSTRAINTS`
WHERE table_name = 'test2';

INSERT INTO test2
VALUES(1,'Tom','tom@126.com',4500);

#错误:Duplicate entry '1' for key 'test2.id'
INSERT INTO test2
VALUES(1,'Tom1','tom1@126.com',4600);

#错误:Duplicate entry 'tom@126.com' for key 'test2.email'
INSERT INTO test2
VALUES(2,'Tom1','tom@126.com',4600);

#可以向声明为unique的字段上添加null值,并且可以多次添加null
INSERT INTO test2
VALUES(2,'Tom1',NULL,4600);

INSERT INTO test2
VALUES(3,'Tom2',NULL,4600);

SELECT * FROM test2;

#4.2 在ALTER TABLE时添加约束
DESC test2;

#方式1:
ALTER TABLE test2
ADD CONSTRAINT un_test2_sal UNIQUE(salary);
#方式2:
ALTER TABLE test2
MODIFY last_name VARCHAR(15) UNIQUE;

#4.3 复合的唯一性约束
CREATE TABLE USER(
id INT,
NAME VARCHAR(15),
`password` VARCHAR(25),

#表级约束
CONSTRAINT uk_user_name_pwd UNIQUE(NAME,PASSWORD)
)

INSERT INTO USER
VALUES(1,'Tom','abc');

#可以成功的
INSERT INTO USER
VALUES(1,'Tom1','abc');


SELECT * FROM USER;

#案例:复合的唯一性约束的案例
#学生表
CREATE TABLE student(
sid INT, #学号
sname VARCHAR(20), #姓名
tel CHAR(11) UNIQUE KEY, #电话
cardid CHAR(18) UNIQUE KEY #身份证号
);
#课程表
CREATE TABLE course(
cid INT, #课程编号
cname VARCHAR(20) #课程名称
);
#选课表
CREATE TABLE student_course(
id INT,
sid INT,  #学号
cid INT,  #课程编号
score INT,  
UNIQUE KEY(sid,cid) #复合唯一
);



INSERT INTO student VALUES(1,'张三','13710011002','101223199012015623');#成功
INSERT INTO student VALUES(2,'李四','13710011003','101223199012015624');#成功
INSERT INTO course VALUES(1001,'Java'),(1002,'MySQL');#成功

SELECT * FROM student;

SELECT * FROM course;

INSERT INTO student_course VALUES
(1, 1, 1001, 89),
(2, 1, 1002, 90),
(3, 2, 1001, 88),
(4, 2, 1002, 56);#成功

SELECT * FROM student_course;

#错误:Duplicate entry '2-1002' for key 'student_course.sid'
INSERT INTO student_course VALUES
(5,2,1002,67);

#4.4 删除唯一性约束
/*
添加唯一性约束的列上也会自动创建唯一索引。
删除唯一约束只能通过删除唯一索引的方式删除。
删除时需要指定唯一索引名，唯一索引名就和唯一约束名一样。
如果创建唯一约束时未指定名称，如果是单列，就默认和列名相同；如果是组合列，那么默认和()
中排在第一个的列名相同。也可以自定义唯一性约束名。

*/

DESC test2;

SELECT * FROM information_schema.`TABLE_CONSTRAINTS`
WHERE table_name = 'test2';

#如何删除唯一性索引
ALTER TABLE test2
DROP INDEX last_name;

ALTER TABLE test2
DROP INDEX un_test2_sal;

#5.PRIMARY KEY (主键约束)
#5.1 在CREATE TABLE 时添加约束

#一个表中最多只能有一个主键约束
#错误:Multiple primary key defined
CREATE TABLE test3(
id INT PRIMARY KEY, #列级约束
last_name VARCHAR(15) PRIMARY KEY,
salary DECIMAL(10,2),
email VARCHAR(25)
);

#主键约束特征:非空且唯一,用于唯一的标识表中的一条记录
CREATE TABLE test3(
id INT PRIMARY KEY, #列级约束
last_name VARCHAR(15),
salary DECIMAL(10,2),
email VARCHAR(25)
);

CREATE TABLE test5(
id INT,
last_name VARCHAR(15),
salary DECIMAL(10,2),
email VARCHAR(25),

#表级约束
CONSTRAINT pk_test5_id PRIMARY KEY(id) #没有必要起名字
);

SELECT * FROM information_schema.`TABLE_CONSTRAINTS`
WHERE table_name = 'test3';

SELECT * FROM information_schema.`TABLE_CONSTRAINTS`
WHERE table_name = 'test5';

DESC test5;

INSERT INTO test3(id,last_name,salary,email)
VALUES(1,'Tom',4500,'tom@126.com');

#错误:Duplicate entry '1' for key 'test3.PRIMARY'
INSERT INTO test3(id,last_name,salary,email)
VALUES(1,'Tom',4500,'tom@126.com');

#错误:Column 'id' cannot be null
INSERT INTO test3(id,last_name,salary,email)
VALUES(NULL,'Tom',4500,'tom@126.com');

SELECT * FROM test3;

CREATE TABLE user1(
id INT,
NAME VARCHAR(15),
PASSWORD VARCHAR(25),

PRIMARY KEY (NAME,PASSWORD)
);

INSERT INTO user1
VALUES(1,'Tom','abc');

INSERT INTO user1
VALUES(1,'Tom1','abc');

SELECT * FROM user1;

#错误:Column 'name' cannot be null
INSERT INTO user1
VALUES(1,NULL,'abc');

#5.2 在ALTER TABLE时添加约束

CREATE TABLE test6(
id INT,
last_name VARCHAR(15),
salary DECIMAL(10,2),
email VARCHAR(25)
);

DESC test6;

ALTER TABLE test6
ADD PRIMARY KEY(id);

#5.3 如何删除主键约束(在实际开发中,不会去删除表中的主键约束!)
ALTER TABLE test6
DROP PRIMARY KEY;

#6.自增长列:AUTO_INCREMENT
#6.1 在CREATE TABLE时添加
CREATE TABLE test7(
id INT PRIMARY KEY AUTO_INCREMENT,
last_name VARCHAR(15)

);

#开发中,一旦主键作用的字段上声明有AUTO_INCREMENT,则我们在添加数据时,就不要给主键
#对应的字段去赋值了
INSERT INTO test7(last_name)
VALUES('Tom');


SELECT * FROM test7;

#当我们向主键(含AUTO_INCREMENT)的字段上添加0或null时,实际上会自动的往上添加指定的字段的数值
INSERT INTO test7(id,last_name)
VALUES(0,'Tom');

INSERT INTO test7(id,last_name)
VALUES(10,'Tom');

#6.2 在ALTER TABLE时添加
CREATE TABLE test8(
id INT PRIMARY KEY ,
last_name VARCHAR(15)
);

DESC test8;

ALTER TABLE test8
MODIFY id INT AUTO_INCREMENT;

#6.3 在ALTER TABLE时删除
ALTER TABLE test8
MODIFY id INT;

#6.4  MySQL 8.0新特性—自增变量的持久化

#在MySQL5.7中演示(放到内存中维护)
CREATE DATABASE dbtest13;

USE dbtest13;


CREATE TABLE test9(
id INT PRIMARY KEY AUTO_INCREMENT
);

INSERT INTO test9
VALUES(0),(0),(0),(0);

SELECT * FROM test9;

DELETE FROM test9 WHERE id = 4;

INSERT INTO test9
VALUES(0);

DELETE FROM test9 WHERE id = 5;

#重启服务器
SELECT * FROM test9;

INSERT INTO test9
VALUES(0);



#在MySQL8.0中演示(持久化到重做日志里)

CREATE TABLE test9(
id INT PRIMARY KEY AUTO_INCREMENT
);

INSERT INTO test9
VALUES(0),(0),(0),(0);

SELECT * FROM test9;

DELETE FROM test9 WHERE id = 4;

INSERT INTO test9
VALUES(0);

DELETE FROM test9 WHERE id = 5;




#7.FOREIGN KEY (外键约束)
#7.1 在CREATE TABLE时添加

#主表和从表:父表和子表

#①先创建主表
CREATE TABLE dept1(
dept_id INT ,
dept_name VARCHAR(15)
);


#②再创建从表
CREATE TABLE emp1(
emp_id INT PRIMARY KEY AUTO_INCREMENT,
emp_name VARCHAR(15),
department_id INT,

#表级约束
CONSTRAINT fk_emp1_dept_id FOREIGN KEY (department_id) REFERENCES dept1(dept_id)
);

#上述操作报错,因为主表中的dept_id上没有主键约束或唯一性约束
#③添加
ALTER TABLE dept1
ADD PRIMARY KEY (dept_id);

DESC dept1;

#④再创建从表
CREATE TABLE emp1(
emp_id INT PRIMARY KEY AUTO_INCREMENT,
emp_name VARCHAR(15),
department_id INT,

#表级约束
CONSTRAINT fk_emp1_dept_id FOREIGN KEY (department_id) REFERENCES dept1(dept_id)
);

DESC emp1;

#7.2演示外键效果
#添加失败
INSERT INTO emp1
VALUES(1001,'Tom',10);

#
INSERT INTO dept1
VALUES(10,'IT');
#在主表dept1中添加了10号部门以后,我们就可以在从表中添加10号部门的员工
INSERT INTO emp1
VALUES(1001,'Tom',10);

#删除失败
DELETE FROM dept1
WHERE dept_id = 10;
#更新失败
UPDATE dept1
SET dept_id=20
WHERE dept_id = 10;

#7.3 在ALTER TABLE 时添加外键约束
CREATE TABLE dept2(
dept_id INT ,
dept_name VARCHAR(15)
);

ALTER TABLE dept2
ADD PRIMARY KEY(dept_id );

CREATE TABLE emp2(
emp_id INT PRIMARY KEY AUTO_INCREMENT,
emp_name VARCHAR(15),
department_id INT

);


ALTER TABLE emp2
ADD CONSTRAINT fk_emp2_dept_id FOREIGN KEY(department_id) REFERENCES dept2(dept_id)

SELECT * FROM information_schema.`TABLE_CONSTRAINTS`
WHERE table_name = 'emp2';



#7.4约束等级
/*
Cascade方式 ：在父表上update/delete记录时，同步update/delete掉子表的匹配记录
Set null方式 ：在父表上update/delete记录时，将子表上匹配记录的列设为null，但是要注意子表的外键列不能为not null
No action方式 ：如果子表中有匹配的记录，则不允许对父表对应候选键进行update/delete操作
Restrict方式 ：同no action， 都是立即检查外键约束
Set default方式 （在可视化工具SQLyog中可能显示空白）：父表有变更时，子表将外键列设置成一个默认的值，但Innodb不能识别

*/


#结论:对于外键约束，最好是采用: ON UPDATE CASCADE ON DELETE RESTRICT 的方式。


#7.5 删除外键约束

#一个表中可以声明多个外键约束

#(1)第一步先查看约束名和删除外键约束
#SELECT * FROM information_schema.table_constraints WHERE table_name = '表名称';#查看某个
#表的约束名
#ALTER TABLE 从表名 DROP FOREIGN KEY 外键约束名;
#（2）第二步查看索引名和删除索引。（注意，只能手动删除）
#SHOW INDEX FROM 表名称; #查看某个表的索引名
#ALTER TABLE 从表名 DROP INDEX 索引名;



SELECT * FROM information_schema.table_constraints WHERE table_name ='emp1';

#删除外键约束
ALTER TABLE emp1
DROP FOREIGN KEY fk_emp1_dept_id;

#再手动删除外键约束对应的普通索引

SHOW INDEX FROM emp1;

ALTER TABLE emp1 DROP INDEX fk_emp1_dept_id; #外键约束名


#7.9 开发场景
#不推荐使用


#8. check 约束 
#MySQL5.7 不支持CHECK约束, MySQL8.0 支持
CREATE TABLE test10(
id INT,
last_name VARCHAR(15),
salary DECIMAL(10,2) CHECK(salary > 2000)
);

INSERT INTO test10
VALUES(1,'Tom',2500);

#添加失败
INSERT INTO test10
VALUES(2,'Tom1',1500);

SELECT * FROM test10;


#9.DEFAULT 约束
#9.1 在CREATE TABLE时添加约束
CREATE TABLE test11(
id INT,
last_name VARCHAR(15),
salary DECIMAL(10,2) DEFAULT 2000
);

DESC test11;

INSERT INTO test11
VALUES(1,'Tom',3000);

SELECT * FROM test11;

INSERT INTO test11(id,last_name)
VALUES(2,'Tom1');

#9.2 在ALTER TABLE时添加约束
CREATE TABLE test12(
id INT,
last_name VARCHAR(15),
salary DECIMAL(10,2)
);

DESC test12;

ALTER TABLE test12
MODIFY salary DECIMAL(10,2) DEFAULT 2500;

#9.3 在ALTER TABLE时删除约束
ALTER TABLE test12
MODIFY salary DECIMAL(10,2);

SHOW 




CREATE TABLE test13(
id INT PRIMARY KEY AUTO_INCREMENT,
last_name VARCHAR(15)
);

INSERT INTO test13(id,last_name)
VALUES(-100,'Tom');

SELECT * FROM test13;

INSERT INTO test13(last_name)
VALUES('Tom');

INSERT INTO test13(id,last_name)
VALUES(0,'Tom');









CREATE TABLE test6(
id INT,
last_name VARCHAR(15),
salary DECIMAL(10,2),
email VARCHAR(25)
);










