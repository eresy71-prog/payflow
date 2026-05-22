create table customers(
customer_id serial primary key,
name varchar(100),
country varchar(50),
email varchar(50)
);

create table merchants(
merchant_id serial primary key,
business_name varchar(150),
category varchar(50),
country varchar(50)
);

create table transactions(
transaction_id serial primary key,
customer_id int,
merchant_id int,
amount decimal(20,2),
status varchar(50),
transaction_timestamp timestamp
);