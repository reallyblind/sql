#第04章_运算符
# 1.算术运算符： + - * /或div %或mod

SELECT 100, 100 + 0, 100 - 0, 100 + 50, 100 + 50 -30, 100 + 35.5, 100 - 35.5
FROM DUAL;

#在SQL中，+没有连接的作用,就表示加法运算.此时，会将字符串转化为数值(隐式转换)
SELECT 100 + '1' 
FROM DUAL;

SELECT 100 + 'a'#将a看作0处理
FROM DUAL;

SELECT 100 + NULL#null参与运算，结果为null
FROM DUAL;

SELECT 100, 100 * 1, 100 * 1.0, 100 / 1.0, 100 / 2,100 + 2 * 5 / 2,100 /3, 100 ,100 DIV 0 
FROM DUAL;#分母如果是0，则结果为null

#取模运算: % mod

#练习:查询员工id为偶数的员工信息
SELECT employee_id,last_name,salary
FROM employees
WHERE employee_id%2=0 ;

#2.比较运算符
#2.1 = <=> <> != < <= > >=
SELECT 1=2,1!=2,1='1',1='a',0='a' #字符串存在隐式转换，如果不成功，则看作0
FROM DUAL; #0 1 1 0 1

SELECT 'a'='a','ab'='ab','a'='b' #两边都是字符串的话，则按照ANSI的比较规则进行比较
FROM DUAL;#1 1 0

SELECT 1=NULL,NULL=NULL #只要有null参与判断，结果就为null
FROM DUAL;#null null

SELECT last_name,salary,commission_pct
FROM employees
WHERE commission_pct=NULL;#此时执行，不会有任何的结果

# <=>:安全等于
SELECT 1 <=> 2,1<=>'1',1<=>'a',0<=>'a'
FROM DUAL;

SELECT 1<=>NULL,NULL <=> NULL
FROM DUAL;

SELECT last_name,salary,commission_pct
FROM employees
WHERE commission_pct<=>NULL;

#2.2 
# IS NULL \ IS NOT NULL\ ISNULL
#练习:查询表中commission_pct 为null的数据有哪些
SELECT last_name,salary,commission_pct
FROM employees
WHERE commission_pct IS NULL;
#或
SELECT last_name,salary,commission_pct
FROM employees
WHERE ISNULL(commission_pct );

#练习:查询表中commission_pct不为null的数据有哪些
SELECT last_name,salary,commission_pct
FROM employees
WHERE commission_pct IS NOT NULL;
#或
SELECT last_name,salary,commission_pct
FROM employees
WHERE NOT commission_pct<=>NULL;

#①LEAST()\GREATEST
SELECT LEAST('g','b','t','m'),GREATEST('g','b','t','m')
FROM DUAL;

SELECT LEAST(first_name,last_name)
FROM employees;

#②BETWEEN...AND（包含边界）
#查询工资在6000到8000的员工信息
SELECT employee_id,last_name,salary
FROM employees
#where salary between 6000 and 8000;
WHERE salary >= 6000 && salary<=8000;
#交换6000和8000，查询不到数据
SELECT employee_id,last_name,salary
FROM employees
WHERE salary BETWEEN 8000 AND 6000;
#查询工资不在6000到8000的员工信息
SELECT employee_id,last_name,salary
FROM employees
WHERE NOT salary BETWEEN 8000 AND 6000;

#④in(set)\ not in(set)
#练习:查询部门为10，20，30部门的员工信息
SELECT last_name,salary,department_id
FROM employees
#where department_id =10 or department_id=20 or department_id=30;
WHERE department_id IN(10,20,30);

#练习:查询工资不是6000，7000，8000的员工信息
SELECT last_name,salary,department_id
FROM employees
#where department_id =10 or department_id=20 or department_id=30;
WHERE salary NOT IN(6000,7000,8000);

#⑤LIKE:模糊查询
#练习:查询last_name中包含字符'a'的员工信息

# %:代表不确定个数的字符(0个，1个或多个)
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%';

#练习：查询last_name中以字符'a'开头的员工信息
SELECT last_name
FROM employees
WHERE last_name LIKE 'a%';

#练习：查询last_name中包含字符'a'并且包含字符'e'的员工信息
#写法一：
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%' AND last_name LIKE '%e%';
#写法二：
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%e%' OR last_name LIKE '%e%a%';

# _ :代表一个不确定的字符
#练习：查询第二个字符是'a'的员工信息
SELECT last_name
FROM employees
WHERE last_name LIKE '__a%';

#练习：查询第2个字符是_且第三个字符是'a'的员工信息
#需要使用转义字符:\
SELECT last_name
FROM employees
WHERE last_name LIKE '_\_a%';

#或者(了解)
SELECT last_name
FROM employees
WHERE last_name LIKE '_$_a%'ESCAPE '$';


#⑥REGEXP \ RLIKE:正则表达式

SELECT 'shkstart' REGEXP '^s', 'shkstart' REGEXP 't$', 'shkstart' REGEXP 'hk'
FROM DUAL;

# 3.逻辑运算符: OR || AND && NOT ! XOR

#or and
SELECT last_name,salary,department_id
FROM employees
#where department_id =10 or department_id=20;
#where department_id =10 and department_id=20;
WHERE department_id =50 AND salary>6000;

#not
SELECT last_name,salary,department_id
FROM employees
#WHERE salary not between 6000 and 8000;
#where commission_pct is not null;
WHERE !commission_pct <=> NULL;

#XOR:追求的"异"
SELECT last_name,salary,department_id
FROM employees
WHERE department_id =50 XOR salary >6000;

/*
OR可以和AND一起使用，但是在使用时要注意两者的优先级，由于AND的优先级高于OR，因此先
对AND两边的操作数进行操作，再与OR中的操作数结合。

*/

#4.位运算符: & | ^ ~ << >>




