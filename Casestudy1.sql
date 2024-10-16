-- 1.Write an SQL query to calculate the number of jobs reviewed per hour for each day in November 2020
select avg(t) as 'avg jobs reviewed per day per hour',
avg(p) as 'avg jobs reviewed per day per second'
from
(select 
ds,
((count(job_id)*3600)/sum(time_spent)) as t,
((count(job_id))/sum(time_spent)) as p
from 
job_data
where 
month(ds)=11
group by ds) a;

-- 2.Write an SQL query to calculate the 7-day rolling average of throughput. Additionally, 
-- explain whether you prefer using the daily metric or the 7-day rolling average for throughput, and why.
SELECT 
    ds,
    c / t AS throughput_per_day,
    c7 / s7 AS throughput_7_day_rolling
FROM (
    SELECT 
        ds,
        COUNT(job_id) AS c,
        SUM(time_spent) AS t,
        SUM(COUNT(job_id)) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS c7,
        SUM(SUM(time_spent)) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS s7
    FROM job_data
    GROUP BY ds
) a
WHERE ds = (SELECT MAX(ds) FROM job_data);

-- 3. Write an SQL query to calculate the percentage share of each language over the last 30 days.
with a as 
(select max(ds)  as m from job_data)
select distinct
language,
(count(event) over(partition by language rows between unbounded preceding and unbounded following) /count(*) 
over(order by ds rows between unbounded preceding and unbounded following) ) * 100 as precentage
  from
(select 
*
from
job_data cross join a
where
datediff(m,date(ds)) between 0 and 30
)a1;

-- 4. Write an SQL query to display duplicate rows from the job_data table.
select actor_id,count(*) as Duplicates from job_data
group by actor_id having count(*)>1;

