#第12章_MySQL数据类型精讲的课后练习

#1.关于属性:character set name

SHOW VARIABLES LIKE 'character_%';


#创建数据库时指明字符集
CREATE DATABASE IF NOT EXISTS dbtest12 CHARACTER SET 'utf8';

SHOW CREATE DATABASE dbtest12;


USE dbtest12;
#创建表的时候,指明表的字符集

CREATE TABLE temp(
id INT
)CHARACTER SET 'utf8';

SHOW CREATE TABLE temp;


#创建表,指明表中的字段时,可以指定字段的字符集
CREATE TABLE temp1(
id INT,
NAME VARCHAR(15) CHARACTER SET 'gbk'

);

SHOW CREATE TABLE temp1;

#2.整型数据类型
USE dbtest12;

CREATE TABLE test_int1(
f1 TINYINT,
f2 SMALLINT,
f3 MEDIUMINT,
f4 INTEGER,
f5 BIGINT
);

DESC test_int1;

INSERT INTO test_int1(f1)
VALUES(12),(-12),(-128),(127);

SELECT *
FROM test_int1;

#错误:Out of range value for column 'f1' at row 1
INSERT INTO test_int1(f1)
VALUES (128);


##
CREATE TABLE test_decimal1(
f1 DECIMAL,
f2 DECIMAL(5,2)
);

DESC test_decimal1;











