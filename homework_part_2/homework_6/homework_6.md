## Задание 1

```
version: "3.9"  
services:
  db:
    image: postgres:12-buster
    container_name: postgress
    ports:
        - 5432:5432
    volumes:
        - /home/d/pg_data:/var/lib/postgresql/data
        - /home/d/pg_dump:/pg_dump
    environment:
        POSTGRES_PASSWORD: 123
        POSTGRES_DB: test_db
        PGDATA: /var/lib/postgresql/data/pgdata
    restart: always
```

## Задание 2

```
postgres-# create database test_db;
CREATE DATABASE
postgres-# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)


postgres=# create user test_admin_user;
CREATE ROLE
postgres-# \du
                                      List of roles
    Role name    |                         Attributes                         | Member of 
-----------------+------------------------------------------------------------+-----------
 postgres        | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 test_admin_user |                                                            | {}



postgres-# CREATE TABLE orders (id SERIAL PRIMARY KEY, name TEXT, price INT);

postgres=# \d orders
                            Table "public.orders"
 Column |  Type   | Collation | Nullable |              Default
--------+---------+-----------+----------+------------------------------------
 id     | integer |           | not null | nextval('orders_id_seq'::regclass)
 name   | text    |           |          |
 price  | integer |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)


postgres=# CREATE TABLE clients (Id SERIAL PRIMARY KEY, surname CHARACTER VARYING(30), country CHARACTER VARYING(30), order_id INT REFERENCES orders (id) );
postgres=# CREATE INDEX country_adr ON clients (country);
postgres=# \d clients
                                    Table "public.clients"
  Column  |         Type          | Collation | Nullable |               Default               
----------+-----------------------+-----------+----------+-------------------------------------
 id       | integer               |           | not null | nextval('clients_id_seq'::regclass)
 surname  | character varying(30) |           |          | 
 country  | character varying(30) |           |          | 
 order_id | integer               |           |          | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "country_adr" btree (country)
Foreign-key constraints:
    "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)

postgres=# GRANT ALL ON clients TO test_admin_user;
GRANT
postgres=# GRANT ALL ON orders TO test_admin_user;
GRANT
postgres=# create user test_simple_user;
CREATE ROLE
postgres=# GRANT SELECT, INSERT, UPDATE, DELETE ON clients TO test_simple_user;
GRANT
postgres=# GRANT SELECT, INSERT, UPDATE, DELETE ON orders TO test_simple_user;
GRANT
```

## Задание 3 
```
postgres=# \d
               List of relations
 Schema |      Name      |   Type   |  Owner
--------+----------------+----------+----------
 public | clients        | table    | postgres
 public | clients_id_seq | sequence | postgres
 public | orders         | table    | postgres
 public | orders_id_seq  | sequence | postgres
(4 rows)

postgres=# SELECT * FROM orders;
 id |  name   | price
----+---------+-------
  2 | Принтер |  3000
  3 | Книга   |   500
  4 | Монитор |  7000
  5 | Гитара  |  4000
  1 | Шоколад |    10
(5 rows)

postgres=# SELECT count(*) FROM orders;
 count
-------
     5
(1 row)


postgres=# SELECT * FROM clients
;
 id |       surname        | country | order_id
----+----------------------+---------+----------
  1 | Иванов Иван Иванович | USA     |
  2 | Петров Петр Петрович | Canada  |
  3 | Иоганн Себастьян Бах | Japan   |
  4 | Ронни Джеймс Дио     | Russia  |
  5 | Ritchie Blackmore    | Russia  |
(5 rows)

postgres=# SELECT count(*) FROM clients;
 count
-------
     5
(1 row)

```

## Задание 4
```
postgres=# UPDATE clients SET order_id = 3 WHERE id = 1;
UPDATE 1
postgres=# UPDATE clients SET order_id = 4 WHERE id = 2;
UPDATE 1
postgres=# UPDATE clients SET order_id = 5 WHERE id = 3;
UPDATE 1

postgres=# SELECT * FROM clients;
 id |       surname        | country | order_id
----+----------------------+---------+----------
  4 | Ронни Джеймс Дио     | Russia  |
  5 | Ritchie Blackmore    | Russia  |
  1 | Иванов Иван Иванович | USA     |        3
  2 | Петров Петр Петрович | Canada  |        4
  3 | Иоганн Себастьян Бах | Japan   |        5
(5 rows)

postgres=# SELECT surname, name FROM clients INNER JOIN orders ON orders.id = order_id;
       surname        |  name
----------------------+---------
 Иванов Иван Иванович | Книга
 Петров Петр Петрович | Монитор
 Иоганн Себастьян Бах | Гитара
(3 rows)

```

## Задание 5

```
postgres=# EXPLAIN SELECT surname, name FROM clients INNER JOIN orders ON orders.id = order_id;
                              QUERY PLAN
-----------------------------------------------------------------------
 Hash Join  (cost=37.00..52.30 rows=420 width=110)
   Hash Cond: (clients.order_id = orders.id)
   ->  Seq Scan on clients  (cost=0.00..14.20 rows=420 width=82)
   ->  Hash  (cost=22.00..22.00 rows=1200 width=36)
         ->  Seq Scan on orders  (cost=0.00..22.00 rows=1200 width=36)
(5 rows)

Чтение данных из таблицы может выполняться несколькими способами. В нашем случае EXPLAIN сообщает, что используется Seq Scan — последовательное, блок за блоком, чтение данных таблицы clients.
cost - это не время, а некое сферическое в вакууме понятие, призванное оценить затратность операции. Первое значение 37.00 — затраты на получение первой строки. Второе — 52.30 — затраты на получение всех строк.
rows — приблизительное количество возвращаемых строк при выполнении операции Seq Scan. Это значение возвращает планировщик.
width — средний размер одной строки в байтах.
```

