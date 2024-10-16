use project3;
-- 1. calc the weekly user engagement


select extract(week from occurred_at) as weeks, 
count(distinct user_id) as no_of_users from events
where event_type="engagement"
group by weeks order by weeks;

-- 2.Write an SQL query to calculate the user growth for the product.
select year, week_no, active_users,
sum(active_users) over(order by year, week_no ) 
as cumm_active_users
from
(select 
    extract(year from a.created_at) as year,
    extract(week from a.created_at)as week_no,
    count(distinct user_id) as active_users
from users a 
where state like'%active%' 
group by year, week_no 
order by year, week_no
)a;

-- 3. Write an SQL query to calculate the weekly retention of users based on their sign-up cohort.
select extract(week from occurred_at) as weeks, 
count(distinct user_id) as no_of_users from events
where event_type="signup_flow" and event_name="complete_signup" 
group by weeks order by weeks; 

-- 4.  Write an SQL query to calculate the weekly engagement per device.


select
device_name,
avg(num_users_using_device) as avg_weekly_users,
avg(times_device_use_current_week) as avg_times_used_weekly
from
(select week(occurred_at) as week,
device as device_name ,
count(distinct user_id) as num_users_using_device,
count(device) as times_device_use_current_week 
from events
where event_name='login'
group by 1,2
order by 1) a
group by 1
order by 2 desc,3 desc;


-- 5. Write an SQL query to calculate the email engagement metrics.

select 
(sum(case when 
email_category="email_opened" then 1 else 0 end)/sum(case when email_category="email_sent" then 1 else 0 end))*100 as open_rate,
(sum(case when 
email_category="email_clickthrough" then 1 else 0 end)/sum(case when email_category="email_sent" then 1 else 0 end))*100 as 
click_rate
from (
	select *, 
	case 
		when action in ("sent_weekly_digest", "sent_reengagement_email") then ("email_sent")
		when action in ("email_open") then ("email_opened")
		when action in ("email_clickthrough") then ("email_clickthrough")
	end as email_category
	from email_events) as alias;