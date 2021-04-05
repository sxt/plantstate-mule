drop table subscriptions;
drop table subscriber_contacts;
drop table event_types;
drop table events;
drop table subscribers;
drop table notification_types;
drop table plants;

create table subscribers (
id integer not null constraint subscribers_pk primary key,
name varchar(100) not null
)
;

create table notification_types (
id integer not null constraint notification_types_pk primary key,
name varchar(100) not null)
;

create table event_types (
id integer not null constraint event_types_pk primary key,
name varchar(100) not null)
;

create table plants (
id integer not null constraint plants_pk primary key,
name varchar(100) not null)
;

create table events (
id integer not null constraint events_pk primary key,
event_type_id integer not null constraint events_fk_1 references event_types (id),
plant_id integer not null constraint events_fk_2 references plants (id)
);

create table subscriber_contacts (
id integer not null constraint subscriber_contacts_pk primary key,
subscriber_id integer not null constraint subscriber_contacts_fk_1 references subscribers (id),
notification_type_id  integer not null constraint subscriber_contacts_fk_2 references notification_types (id),
notification_address varchar(100) not null,
constraint subscriber_contacts_uq unique (subscriber_id, notification_type_id)
)
;

create table subscriptions (
id integer not null constraint subscriptions_pk primary key,
subscriber_id integer not null constraint subscriptions_fk_1 references subscribers (id),
plant_id  integer not null constraint subscriptions_fk_2 references plants (id),
event_type_id integer not null constraint subscriptions_fk_3 references event_types (id),
constraint subscriptions_uq unique (subscriber_id, plant_id, event_type_id)
)
;

insert into plants values (1, 'Karl');

insert into notification_types values (1, 'Email');
insert into notification_types values (2, 'SMS');

insert into event_types values (1, 'Dry detected');
insert into event_types values (2, 'Moist detected');
insert into event_types values (3, 'Test Event');

insert into subscribers values (1, 'Arnold Layne');

insert into subscriber_contacts values (1, 1, 1, 'blahblah@xxx.com');
insert into subscriber_contacts values (2, 1, 2, '+9999999999');
-- correction:
update subscriber_contacts set notification_address = '+ 9999999999' where id = 2;

insert into subscriptions values (1, 1, 1, 1);
insert into subscriptions values (2, 1, 1, 2);

-- Subscribers for an event:
select et.*, p.*, sn.*, sr.*, sc.notification_address, nt.name
from subscriptions sn
join event_types et   on et.id = sn.event_type_id
join plants p  on p.id = sn.plant_id
join subscribers sr on sn.subscriber_id = sr.id
join subscriber_contacts sc on sc.subscriber_id = sr.id
join notification_types nt on nt.id = sc.notification_type_id
where et.id = 1
and p.id = 1;

select et.id as event_type_id, et.name as event_type_name,
p.id as plant_id, p.name as plant_name, 
sn.id as subscription_id,
sr.id as subscriber_id, sr.name as subscriber_name,
sc.notification_address,
nt.id as notification_type_id, nt.name as notification_type_name
from subscriptions sn
join event_types et   on et.id = sn.event_type_id
join plants p  on p.id = sn.plant_id
join subscribers sr on sn.subscriber_id = sr.id
join subscriber_contacts sc on sc.subscriber_id = sr.id
join notification_types nt on nt.id = sc.notification_type_id
where et.id = 1
and p.id = 1;

create view subscription_data as 
select et.id as event_type_id, et.name as event_type_name,
p.id as plant_id, p.name as plant_name, 
sn.id as subscription_id,
sr.id as subscriber_id, sr.name as subscriber_name,
sc.notification_address,
nt.id as notification_type_id, nt.name as notification_type_name
from subscriptions sn
join event_types et   on et.id = sn.event_type_id
join plants p  on p.id = sn.plant_id
join subscribers sr on sn.subscriber_id = sr.id
join subscriber_contacts sc on sc.subscriber_id = sr.id
join notification_types nt on nt.id = sc.notification_type_id;

select * from subscription_data
where event_type_id = 1
and plant_id = 1;

select * from subscription_data
order by 1;

commit;