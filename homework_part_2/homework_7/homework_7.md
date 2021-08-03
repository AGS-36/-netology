## Задание 1

```
version: "3.9"
services:
  db:
    image: mysql:latest
    container_name: mysql
    ports:
        - 3307:3306
    volumes:
        - /home/rod/mysql_data:/var/lib/mysql
        - /home/rod/mysql_dump:/pg_dump
        - /home/rod/mysql_conf/conf.d:/etc/mysql/conf.d
    environment:
        MYSQL_ROOT_PASSWORD: 123
        MYSQL_DATABASE: test_db
    restart: always
```
```
mysql> status
--------------
mysql  Ver 8.0.26 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		18
Current database:	test_db
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.26 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			31 min 5 sec

Threads: 2  Questions: 61  Slow queries: 0  Opens: 167  Flush tables: 3  Open tables: 85  Queries per second avg: 0.032
--------------
root@8deaea011141:/mysql_dump# ls
test_dump.sql
root@8deaea011141:/mysql_dump# mysql -u root -p test_db < test_dump.sql
Enter password:

mysql> USE test_db;
mysql> SHOW TABLES;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql> SELECT * FROM orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.00 sec)

mysql> SELECT * FROM orders WHERE price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)
```

## Задание 2
```
mysql> CREATE USER 'test'@'localhost' IDENTIFIED WITH mysql_native_password BY 'test-pass' PASSWORD EXPIRE INTERVAL 180 DAY FAILED_LOGIN_ATTEMPTS 3 ATTRIBUTE '{"name": "James", "surname": "Pretty"}';
Query OK, 0 rows affected (0.01 sec)

mysql> ALTER USER 'test'@'localhost' WITH MAX_QUERIES_PER_HOUR 100;
Query OK, 0 rows affected (0.04 sec)


mysql> GRANT SELECT ON test_db.orders TO 'test'@'localhost';
Query OK, 0 rows affected (0.01 sec)

mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES;
+------------------+-----------+----------------------------------------+
| USER             | HOST      | ATTRIBUTE                              |
+------------------+-----------+----------------------------------------+
| root             | %         | NULL                                   |
| mysql.infoschema | localhost | NULL                                   |
| mysql.session    | localhost | NULL                                   |
| mysql.sys        | localhost | NULL                                   |
| root             | localhost | NULL                                   |
| test             | localhost | {"name": "James", "surname": "Pretty"} |
+------------------+-----------+----------------------------------------+
6 rows in set (0.00 sec)
```

## Задание 3

```

mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)o

mysql> SHOW PROFILES;
+----------+------------+-------------------+
| Query_ID | Duration   | Query             |
+----------+------------+-------------------+
|        1 | 0.00032200 | SELECT DATABASE() |
|        2 | 0.00180175 | show databases    |
|        3 | 0.00263700 | show tables       |
+----------+------------+-------------------+
3 rows in set, 1 warning (0.00 sec)

Данная команда показывает все выполненные запросы за сессию с временем выполнения. show profiles по умолчанию показывает профили для 15 запросов. Кол-во запрсов можно увеличить с помощью параметра profiling_history_size, но не более чем до 100.

root@8deaea011141:~# mysqlshow -u root -p -i test_db
Enter password:
Database: test_db
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time         | Check_time | Collation          | Checksum | Create_options | Comment |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| orders | InnoDB | 10      | Dynamic    | 5    | 3276           | 16384       | 0               | 0            | 0         | 6              | 2021-08-03 11:19:28 | 2021-08-03 11:19:28 |            | utf8mb4_0900_ai_ci |          |                |         |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+


mysql> ALTER TABLE orders engine=MyISAM;
Query OK, 5 rows affected (0.04 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+----------------------------------+
| Query_ID | Duration   | Query                            |
+----------+------------+----------------------------------+
|        1 | 0.00032200 | SELECT DATABASE()                |
|        2 | 0.00180175 | show databases                   |
|        3 | 0.00263700 | show tables                      |
|        4 | 0.00059325 | SELECT * FROM orders             |
|        5 | 0.03748125 | ALTER TABLE orders engine=MyISAM |
|        6 | 0.00065500 | SELECT * FROM orders             |
|        7 | 0.07841275 | ALTER TABLE orders engine=InnoDB |
|        8 | 0.00068250 | SELECT * FROM orders             |
+----------+------------+----------------------------------+
8 rows in set, 1 warning (0.00 sec)
```

## Задание 4 

```
innodb_flush_log_at_trx_commit=2
innodb_file_per_table=1
innodb_log_buffer_size=1M
innodb_buffer_pool_size = 30
innodb_log_buffer_size = 100M
```
