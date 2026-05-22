insert into customers (customer_id, name, country, email)
select
row_number() over(order by c.customer_id) as customer_id,
c.customer_id as name,
'Brazil' as country,
concat(c.customer_id, '@customer.payflow.com') as email
from (select distinct customer_id from raw_customer) c;

-- changing column type in customer table to text
alter table customers alter column email type text;

select * from customers;

insert into merchants(merchant_id, business_name, category, country)
select row_number() over(order by s.seller_id) as merchant_id,
s.seller_id as business_name,
'ecomerce' as category,
'Brazil' as country
from (select distinct seller_id from raw_seller) s;

alter table raw_seller rename column sellr_id to seller_id;
select * from merchants;

insert into transactions( customer_id, merchant_id, amount, status, transaction_timestamp)
select  
	dense_rank() over (order by ro.customer_id) as customer_id,
    dense_rank() over (order by roi.seller_id) as merchant_id,
    roi.price as amount,
    ro.order_status as status,
    ro.order_purchase_timestamp as transaction_timestamp
from raw_order ro
inner join raw_order_items roi
    on ro.order_id = roi.order_id
left join raw_order_payment rop
    on ro.order_id = rop.order_id
where rop.payment_sequential = 1
   or rop.payment_sequential is null
   order by ro.order_purchase_timestamp, ro.order_id, roi.order_item_id;


select * from transactions;