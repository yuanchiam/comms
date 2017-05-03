use ychiam;

create table ychiam.watchathon_subs as
select account_id, signup_date
from dse.subscrn_d
where is_open_access_signup=1
and signup_date between 20170403 and 20170409;

create table ychiam.contact_base as
select c1.*, rcr.has_recontact_cnt
from
    (select c.account_id, c.contact_code, c.answered_cnt, c.member_ticket_cnt, c.dsat_survey_response_cnt,
    c.dsat_negative_survey_response_cnt, c.talk_duration_secs, c.acw_duration_secs, c.answer_hold_duration_secs,
    c.has_referral_gate, c.is_referred_externally,
    c.contact_subchannel_id, c.call_center_id, c.contact_start_ts, c.ticket_gate_level2_desc
    from dse.cs_contact_f c
    join dse.cs_transfer_type_d trt on c.transfer_type_id = trt.transfer_type_id
    join dse.cs_contact_skill_d r on r.contact_skill_id=c.contact_skill_id
    join dse.cs_call_center_d dc 
        on dc.call_center_id=c.call_center_id 
    where c.fact_utc_date >=20170403    
    --always include these extra filters to remove research and escalated tickets or your numbers will be inflated
    and r.escalation_code not in ('G-Escalation', 'SC-Consult','SC-Escalation','Corp-Escalation')
    and trt.major_transfer_type_desc not in ('TRANSFER_OUT')
    and c.answered_cnt>0
    and c.contact_subchannel_id in ('Phone', 'Chat', 'voip','InApp', 'MBChat')
    and c.contact_origin_country_code='US') c1
left join 
    (select contact_code, has_recontact_cnt 
    from dse.cs_recontact_f 
    where days_to_recontact_cnt<=7
    and has_recontact_cnt =1
    and fact_utc_date >= cast(date_format((current_date - interval '3' month ), '%Y%m%d') as bigint)  
    group by contact_code, has_recontact_cnt) rcr 
on c1.contact_code = rcr.contact_code;

select *
from
    ychiam.watchathon_subs s
join
    ychiam.contact_base b
on s.account_id=b.account_id

-- break



select sum((coalesce(c3.answered_cnt,0))) volume,
sum((case when c3.has_recontact_cnt is null then 0 else 1 end)) recontact7,
sum((coalesce(c3.member_ticket_cnt,0))) member_tickets,
cast(sum((case when c3.has_recontact_cnt is null then 0 else 1 end)) as float)/cast(sum((coalesce(c3.member_ticket_cnt,0))) as float) rcr,
sum((coalesce(c3.dsat_survey_response_cnt,0))) survey_responses,
sum((coalesce(c3.dsat_negative_survey_response_cnt,0))) negative_survey_responses,
cast(sum((coalesce(c3.dsat_negative_survey_response_cnt,0))) as float)/cast(sum((coalesce(c3.dsat_survey_response_cnt,0))) as float) dsat,
sum((coalesce(c3.has_referral_gate,0))) has_referral_gate,
sum((coalesce(c3.is_referred_externally,0))) is_referred_externally,
sum((((coalesce(c3.talk_duration_secs,0)+coalesce(c3.acw_duration_secs,0)+coalesce(c3.answer_hold_duration_secs,0))/60.0))) handle_time,
sum((((coalesce(c3.talk_duration_secs,0)+coalesce(c3.acw_duration_secs,0)+coalesce(c3.answer_hold_duration_secs,0))/60.0)))/sum((coalesce(c3.answered_cnt,0))) aht
from
(select c2.*
from 
(select c1.*, rcr.has_recontact_cnt
from
    (select c.account_id, c.contact_code, c.answered_cnt, c.member_ticket_cnt, c.dsat_survey_response_cnt,
    c.dsat_negative_survey_response_cnt, c.talk_duration_secs, c.acw_duration_secs, c.answer_hold_duration_secs,
    c.has_referral_gate, c.is_referred_externally
    from dse.cs_contact_f c
    join dse.cs_transfer_type_d trt on c.transfer_type_id = trt.transfer_type_id
    join dse.cs_contact_skill_d r on r.contact_skill_id=c.contact_skill_id
    join dse.cs_call_center_d dc 
        on dc.call_center_id=c.call_center_id 
    where c.fact_utc_date >=20170403    
    --always include these extra filters to remove research and escalated tickets or your numbers will be inflated
    and r.escalation_code not in ('G-Escalation', 'SC-Consult','SC-Escalation','Corp-Escalation')
    and trt.major_transfer_type_desc not in ('TRANSFER_OUT')
    and c.answered_cnt>0
    and c.contact_subchannel_id in ('Phone', 'Chat', 'voip','InApp', 'MBChat')
    and c.contact_origin_country_code='US') c1
left join 
    (select contact_code, has_recontact_cnt 
    from dse.cs_recontact_f 
    where days_to_recontact_cnt<=7
    and has_recontact_cnt =1
    and fact_utc_date >= cast(date_format((current_date - interval '3' month ), '%Y%m%d') as bigint)  
    group by contact_code, has_recontact_cnt) rcr 
on c1.contact_code = rcr.contact_code) c2
join
    (select account_id
    from dse.subscrn_d
    where is_open_access_signup=1
    and signup_date>=20170403
    and signup_date<=20170409) s
on c2.account_id=s.account_id) c3
