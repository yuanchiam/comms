select 
    msg.message_guid,
    msg.send_utc_dateint,
    msg.account_id,
    msg.message_id,
    msg.country_iso_code,
    msg.status_desc,
    msg.fail_reason_short_desc
from dse.msg_send_f msg
join etl.cs_message_id_entry ids
on msg.account_id=ids.account_id

