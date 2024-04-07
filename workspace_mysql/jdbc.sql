CREATE DATABASE test;

CREATE TABLE tb_user(
id INT,
username VARCHAR(20),
`password` VARCHAR(32)
);

INSERT INTO tb_user
VALUES(1,'zhangsan',123),(2,'lisi',234);

SELECT * FROM tb_user;