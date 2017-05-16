select 
    msg.message_guid,
    msg.send_utc_dateint,
    msg.account_id,
    msg.message_id,
    msg.country_iso_code,
    msg.status_desc,
    msg.fail_reason_short_desc,
    msgd.message_name,
    msgd.channel
from dse.msg_send_f msg
join etl.cs_message_id_entry ids
on msg.account_id=ids.account_id
join dse.msg_message_d msgd
on msg.message_id=msgd.message_id
where msg.send_utc_dateint>20170101

-- temp table

select 
    a.message_guid,
    a.send_utc_dateint,
    a.account_id,
    a.message_id,
    a.country_iso_code,
    a.status_desc,
    a.fail_reason_short_desc,
    b.message_name,
    b.channel
from dse.msg_send_f a
join dse.msg_message_d b
on a.message_id=b.message_id
where a.message_id=12853
and a.send_utc_dateint>20170501
limit 100;
