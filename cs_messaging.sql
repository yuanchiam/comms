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
join message_ids ids
on msg.message_id=ids.message_id
join dse.msg_message_d msgd
on msg.message_id=msgd.message_id
where msg.send_utc_dateint >= {from_date}
and msg.send_utc_dateint <= {to_date_m1}

---
---
---

use ychiam;
CREATE TABLE ychiam.cs_message_alloc (
    message_guid string,
    account_id bigint,
    message_id bigint,
    country_iso_code string,
    status_desc string,
    fail_reason_short_desc string,
    message_name string,
    channel string
)
PARTITIONED BY (send_utc_dateint bigint);

---
---
---

select 
    msg_details.message_guid,
    msg_details.send_utc_dateint,
    msg_details.account_id,
    msg_details.message_id,
    msg_details.country_iso_code,
    msg_details.status_desc,
    msg_details.fail_reason_short_desc,
    msg_details.message_name,
    msg_details.channel
    contact_details.*

from

(select 
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
on msg.message_id=ids.message_id
join dse.msg_message_d msgd
on msg.message_id=msgd.message_id
where msg.send_utc_dateint>20170101 ) msg_details

join

(select
    cf.contact_code,
    cf.call_center_id,
    cf.account_id,
    cf.contact_origin_country_code,
    cf.contact_subchannel_id,
    cf.transfer_type_id,
    cf.contact_skill_id,
    cf.contact_duration_secs,
    cf.customer_hold_duration_secs,
    cf.talk_duration_secs,
    cf.acw_duration_secs,
    cf.answer_hold_duration_secs,
    cf.answered_cnt,
    cf.ticket_gate_disposition_id,
    cf.ticket_gate_disposition_desc,
    cf.ticket_gate_level0_id,
    cf.ticket_gate_level0_desc,
    cf.ticket_gate_level1_id,
    cf.ticket_gate_level1_desc,
    cf.ticket_gate_level2_id,
    cf.ticket_gate_level2_desc,
    cf.ticket_gate_level3_id,
    cf.ticket_gate_level3_desc,
    cf.dsat_survey_response_cnt,
    cf.negative_survey_response_cnt,
    cf.dsat_negative_survey_response_cnt,
    cf.makegood_amt,
    cf.makegood_cnt,
    cf.kb_articles_used_cnt,
    cf.kb_search_cnt,
    cf.fact_utc_date,
    cc.call_center_desc,
    case when rcr.contact_code is null then 0 else 1 end as rcr7,
    (cf.acw_duration_secs+cf.customer_hold_duration_secs+cf.answer_hold_duration_secs+cf.talk_duration_secs)/60.0 as ht
from dse.cs_contact_f cf
join dse.cs_transfer_type_d trt on cf.transfer_type_id = trt.transfer_type_id
join dse.cs_contact_skill_d r on r.contact_skill_id=cf.contact_skill_id
join dse.cs_call_center_d cc on cc.call_center_id=cf.call_center_id 

left join (select contact_code from dse.cs_recontact_f
    where days_to_recontact_cnt<=7
    and has_recontact_cnt =1
    and fact_utc_date >= cast(date_format((current_date - interval '3' month ), '%Y%m%d') as bigint)  
    group by contact_code) rcr on cf.contact_code = rcr.contact_code

where cf.fact_utc_date >= 20170101    
--always include these extra filters to remove research and escalated tickets or your numbers will be inflated
and r.escalation_code not in ('G-Escalation', 'SC-Consult','SC-Escalation','Corp-Escalation')
and trt.major_transfer_type_desc not in ('TRANSFER_OUT')
and cf.answered_cnt>0
and cf.contact_subchannel_id in ('Phone', 'Chat', 'voip','InApp', 'MBChat') ) contact_details

on msg_details.account_id=contact_details.account_id

-- consider only calls after email/message sent
where contact_details.fact_utc_date>=msg_details.send_utc_dateint
