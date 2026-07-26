-- question: is the delay caused by the distance or is it the destination?


with main as (
select 
	order_id,
	customer_id,
	order_delivered_carrier_date,
	order_purchase_timestamp,
	extract(epoch from (order_delivered_carrier_date - order_purchase_timestamp)) /86400 as seller_handling,
	order_delivered_customer_date,
	extract(epoch from (order_delivered_customer_date - order_delivered_carrier_date))/86400 as transit,
	extract(epoch from (order_delivered_customer_date - order_estimated_delivery_date))/86400 as delay_days
from orders
where order_status = 'delivered'
and order_delivered_carrier_date >= order_purchase_timestamp
and order_delivered_customer_date is not null
)



-- checking if there are orders with multiple items and multiple sellers
/*select 
	order_id, 
	count(*) num_items, 
	count(distinct seller_id) num_seller
from order_items
group by order_id
having count(*) > 1
order by count(distinct seller_id) desc
limit 5;*/


-- there are 1278 orders having multiple sellers, ~1.3% of orders
/*select count(*) 
from (
    select order_id
    from order_items
    group by order_id
    having count(distinct seller_id) > 1
) t;*/

-- first seller taken as representative. using first item's seller as representative
,order_seller as (
select 
	order_id,
	seller_id
from order_items 
where order_item_id = 1
)

, final as (
select
	m.order_id,
	os.seller_id,
	m.customer_id,
	s.seller_state,
	c.customer_state,
	case when s.seller_state = c.customer_state then 'same state'
		else 'cross' end as cust_seller_state,
	case when delay_days > 0 then 'late'
		else 'on time' end as late_or_not,
	m.transit
from main m
left join order_seller os
on m.order_id = os.order_id 
left join customers c
on m.customer_id = c.customer_id
left join sellers s
on os.seller_id = s.seller_id
)

select 
	cust_seller_state,
	count(*) total_orders,
	count(*) filter (where late_or_not = 'late') late_orders,
	avg(transit) filter (where late_or_not = 'late') avg_transit_late,
	count(*) filter (where late_or_not = 'late')::numeric / count(*) as late_rate 
from final
group by 1
