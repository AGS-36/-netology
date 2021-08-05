## Задание 1

```
version: "3.9"  
services:
  db:
    image: postgres:latest
    container_name: postgress
    ports:
        - 5432:5432
    volumes:
        - /home/rod/pg_data:/var/lib/postgresql/data
        - /home/rod/pg_dump:/pg_dump
    environment:
        POSTGRES_PASSWORD: 123
        POSTGRES_DB: test_db
        PGDATA: /var/lib/postgresql/data/pgdata
    restart: always
    
- \l
- \c database
- \dt+
- \d table_name
- \q

```

## Задание 2
```
postgres-# create database test_db;
CREATE DATABASE

psql -U postgres test_db < test_dump.sql

test_db=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE

test_db=# select tablename, attname, avg_width from pg_stats where tablename='orders';
 tablename | attname | avg_width
-----------+---------+-----------
 orders    | id      |         4
 orders    | title   |        16
 orders    | price   |         4
(3 rows)

test_db=# select distinct on (1) * from (select tablename, attname, avg_width from pg_stats where tablename='orders') as foo order by 1, avg_width desc;
 tablename | attname | avg_width
-----------+---------+-----------
 orders    | title   |        16
(1 row)
```

## Задание 3

```
test_db=# CREATE TABLE orders_1 (
test_db(# CHECK (price>499)
test_db(# ) INHERITS ( orders);
CREATE TABLE

test_db=# CREATE TABLE orders_2 (
test_db(# CHECK (price<=499)
test_db(# ) INHERITS ( orders );
CREATE TABLE

test_db=# \d
              List of relations
 Schema |     Name      |   Type   |  Owner
--------+---------------+----------+----------
 public | orders        | table    | postgres
 public | orders_1      | table    | postgres
 public | orders_2      | table    | postgres
 public | orders_id_seq | sequence | postgres
(4 rows)

test_db=# INSERT INTO orders_1 SELECT * FROM orders where price > 499;
INSERT 0 3

test_db=# select * from orders_1;
 id |       title        | price
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)


test_db=# INSERT INTO orders_2 SELECT * FROM orders where price <= 499;
INSERT 0 5
test_db=# select * from orders_2;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
Мы на базовую таблицу должны добавить некоторое правило, чтобы, когда мы будем работать с нашей основной таблицей orders, вставка на запись с price > 499 попала именно в order_1 или c price <=499 попала в order_2.  

CREATE RULE insert_to_orders_1 AS ON INSERT TO orders WHERE (price > 499) DO INSTEAD INSERT orders_1 VALUES (NEW.*)
```

## Задание 5

```
root@c10f3ab14c87:/pg_dump# pg_dump -U postgres test_db > /pg_dump/test_db.pgsql.backup
root@c10f3ab14c87:/pg_dump# ls
test_db.pgsql.backup  test_dump.sql

test_db=# alter table orders add unique(title);
ALTER TABLE
```
