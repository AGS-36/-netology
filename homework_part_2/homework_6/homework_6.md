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


postgres=# CREATE TABLE clients (id SERIAL PRIMARY KEY, family TEXT, country TEXT, order_name TEXT);
postgres=# CREATE INDEX country_idx ON clients(country);
CREATE INDEX

```

Задание 3 
```
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
```
