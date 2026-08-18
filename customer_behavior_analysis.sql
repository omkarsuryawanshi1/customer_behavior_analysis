select * from customer limit 10;

select gender,sum(purchase_amount) as revenue
from customer
group by gender;

-- Which customer used a discount but still spent more then the average purchase amount
select customer_id,purchase_amount 
from customer
where discount_applied = 'Yes' and purchase_amount >= (select avg(purchase_amount) from customer);

-- Q3 Which are the top 5 product with the higest average revirew rating
select item_purchased,round(avg(review_rating::numeric),2) as ratings
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5;

--Q4 Compare the average purchase amounts between standard and express shipping
select shipping_type,round(avg(purchase_amount),2) as "average purchase amount"
from customer
where shipping_type in ('Standard','Express')
group by shipping_type;

--Q5 Do subscribed customers spend more compare average spend and total revenue between subscribers and non-subscribers
select subscription_status,
count(customer_id) as total_customers,
round(avg(purchase_amount),2) as average_purchase,
sum(purchase_amount) as Total_purchased
from customer
group by subscription_status
order by Total_purchased,average_purchase desc;

--Q6 which 5 product have the highest percentage of purchases with discound applied
select item_purchased,
round(100*sum(case when discount_applied = 'Yes' Then 1 else 0 end)/count(*),2) as discount_rate
from customer
group by item_purchased 
order by discount_rate desc
limit 5;

--Q7 segment customers info New,Returning, and Loyal based on their total number of previous purchas, and show the count of each segment
with customer_type as (
select customer_id,previous_purchases,
case
 	when previous_purchases = 1 then 'New'
	when previous_purchases between 2 and 10 then 'Returning'
	else 'Loyal'
	end as customer_segment
from customer
)

select customer_segment,count(*) as "Number"
from customer_type
group by customer_segment;

--Q8 what are the top 3 most purchased products within each category
with item_count as (
select category,item_purchased,
count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id) desc) as item_rank
from customer
group by category,item_purchased
)
select item_rank,category,item_purchased,total_orders
from item_count
where item_rank <= 3;

--Q9 Are customers who are repeat buyers (more then 5 purchases) also likely to subscribe?
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status;


--Q10 what is the revenue contribution of each age group?
select age_group,sum(purchase_amount) as Total_revenue
from customer
group by age_group
order by Total_revenue desc;