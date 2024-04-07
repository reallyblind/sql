#第07章_单行函数
SELECT 
ABS(-123),ABS(32),SIGN(-23),SIGN(43),PI(),CEIL(32.32),CEILING(-43.23),FLOOR(32.32),
FLOOR(-43.23),MOD(12,5)
FROM DUAL;

SELECT REPLACE('hello','l','mm');

SELECT DATE_FORMAT(CURDATE(),GET_FORMAT(DATE,'USA'))
FROM DUAL;

SELECT employee_id,salary, CASE WHEN salary>=15000 THEN '高薪'
				WHEN salary >= 10000 THEN '潜力'
				WHEN salary<=8000 THEN '小屌丝'
				ELSE '草根' END "details"
FROM employees;

SELECT employee_id,salary,last_name,department_id,
CASE department_id WHEN 10 THEN salary*1.1
		   WHEN 20 THEN salary*1.2
		   WHEN 30 THEN salary*1.3
		    END "details"
FROM employees
WHERE department_id IN(10,20,30);


SELECT MD5('mysql'),SHA('mysql')
FROM DUAL;

SELECT ENCODE('atguigu','mysql')
FROM DUAL;

SELECT VERSION(),CONNECTION_ID(),DATABASE(),SCHEMA(),
USER(),CURRENT_USER(),CHARSET('尚硅谷'),COLLATION('尚硅谷')
FROM DUAL;





