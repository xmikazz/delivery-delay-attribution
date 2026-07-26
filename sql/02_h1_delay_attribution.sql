-- question: does the delay happen before or after carrier handover?

-- there are 8 distinct order statuses from the facts tabe
select 
	distinct ORDER_STATUS from orders;

-- there are 96478 orders that were delivered. only these will be considered for this analysis 
select 
	order_status,
	COUNT(*)
from orders
group by 1
order by count(*) desc;


-- transit is 2.89x handling average of 9.33 days vs 3.23 on seller side 
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

-- Handling adds ~2.8 extra days, transit adds ~17.8. Transit contributes roughly 86% of the excess days on late orders.
,delivery_sla as (
select 
	case when delay_days > 0 then 'late'
	else 'on time' end as delivery_sla,
	count(*) as num_of_deliveries,
	AVG(seller_handling) as avg_seller_handling,
	AVG(transit) as avg_transit
from main
group by 1
)

-- 2467 of 7822 late orders (32%) took over 30 days in transit. the worst took 205 days
/*select
	max(transit) as worst,
	count(*) filter (where transit > 30) as catastrophic,
	count(*) as late_orders
from main
where delay_days > 0*/
 
-- late orders by customer state
select
	c.customer_state,
	count(*) as total_orders,
	count(*) filter (where delay_days > 0) as late_orders,
	count(*) filter (where delay_days > 0)::numeric / count(*) as late_rate,
	avg(transit) filter (where delay_days > 0) as avg_transit_late_orders
from main m
left join customers c
on m.customer_id = c.customer_id
group by 1
order by late_rate desc
