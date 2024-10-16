create database project3;
use project3;
show variables like 'secure_file_priv';

#Table 1 users

create table users(
user_id	int,
created_at varchar(100),
company_id	int,
language varchar(50),	
activated_at varchar(100),
state varchar(50));


show variables like 'secure_file_priv';

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Table-1 users.csv"
into table users
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

alter table users add column temp_created_at datetime;
update users set temp_created_at = STR_TO_DATE(created_at, '%d-%m-%Y %H:%i');
alter table users drop column created_at;
alter table users change column temp_created_at created_at datetime;



#table 2
create table events(
user_id int null,
occurred_at	varchar(100) null,
event_type	varchar(50) null,
event_name	varchar(100) null,
location	varchar(50) null,
device	varchar(50) null,
user_type int null
);


load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv"
into table events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

desc events;
alter table events add column temp_occurred_at datetime;
update events set temp_occurred_at = STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i');
alter table events drop column occurred_at;
alter table events change column temp_occurred_at occurred_at datetime;

#Table 3 
create table email_events(
user_id int,
occurred_at varchar(100),
action	varchar(100),
user_type int);

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv"
into table email_events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;



