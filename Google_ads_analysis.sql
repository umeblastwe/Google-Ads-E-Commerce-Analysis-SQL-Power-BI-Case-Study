Select * from [Google Ads]

-- Total Conversation & Coversation funnel in Percentage

Select type, count(type) as Total_Conversation_funnel,
Round(Count(type) * 100 / sum(count(*)) over () , 2)  as Percentage_of_Coversation_funnel
From [Google Ads]
Group by type

-- Percentage of Coversations Funnels By Countriies
With Ads as (
	Select Country, type, count(*) as Total_Conversation_funnel,
	CONVERT(DECIMAL(10,2),(Count(*) * 100 / sum(count(*)) over ())) as Percentage_By_Country_Coversation_funnel
	From [Google Ads]
	Where country in ('US')
	Group by type, country
	)
Select country, 
    type, 
    Total_Conversation_funnel, 
    Percentage_By_Country_Coversation_funnel
from Ads
Order by Percentage_By_Country_Coversation_funnel desc

-- New vs Repeat Buyers
With ads as (
Select user_id, ga_session_id
From [Google Ads]
Where type = 'purchase'
)
Select user_id, COUNT(DISTINCT ga_session_id) as Unique_sessions,
CASE 
     WHEN COUNT(DISTINCT ga_session_id) = 1 THEN 'One-time Buyer'
     ELSE 'Repeat Customer'
    END AS customer_type
    From ads
    Group by user_id

-- Device analysis
With ads as (
Select
device,
sum(case when type = 'add_to_cart' then 1 else 0 End) as Total_carts,
sum(case when type = 'begin_checkout' then 1 else 0 End) as Total_checkouts,
sum(case when type = 'purchase' then 1 else 0 End) as Total_purchase
From [Google Ads]
Group by device
)
Select
device,
Total_carts,
Total_checkouts
Total_purchase,
CASE 
        WHEN Total_checkouts = 0 THEN 0 
        ELSE CONVERT(DECIMAL(10,2), (Total_purchase * 100.0 / Total_checkouts)) 
    END as checkout_to_purchase_rate,
CASE 
        WHEN Total_carts = 0 THEN 0 
        ELSE CONVERT(DECIMAL(10,2), (Total_checkouts * 100.0 / Total_carts)) 
    END as cart_to_checkout_rate
From ads


Select  CONVERT(nvarchar(7), Order_date, 120) AS year_month,

-- Purchases By Month

Select CONVERT(nvarchar(7), date, 120) AS year_month,
   Sum(case when type = 'purchase' then 1 else 0 end) as Total_purchases
from [Google Ads]
Group by CONVERT(nvarchar(7), date, 120)
Order by CONVERT(nvarchar(7), date, 120)

-- Hourly Purchase Analysis

Select FORMAT(cast(date as datetime), 'hh tt') as Time,
Sum(case when type = 'purchase' then 1 else 0 end) as Total_purchases
from [Google Ads]
Group by FORMAT(cast(date as datetime), 'hh tt')
Order by Total_purchases desc