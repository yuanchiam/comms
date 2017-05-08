-- in Hive

GRANT Select on TABLE vault.device_esn_account_d to USER ychiam;
-- https://confluence.netflix.com/display/DATA/Vault+Warehouse

use ychiam;
create table ychiam.watchathon_subs as
select distinct b1.account_id
from
    (select a.esn
    from vault.device_esn_account_d a
    join dse.subscrn_d b
    on a.account_id=b.account_id
    where b.is_open_access_signup=1
    and b.signup_date between 20170403 and 20170409) a1
join
    (select esn, account_id
    from vault.device_esn_account_d) b1
on a1.esn=b1.esn;

--create table ychiam.watchathon_subs as
--select account_id, signup_date
--from dse.subscrn_d
--where is_open_access_signup=1
--and signup_date between 20170403 and 20170409;

-- in Tableau SQL
select c1.*, rcr.has_recontact_cnt
from
    (select c.account_id, c.contact_code, c.answered_cnt, c.member_ticket_cnt, c.dsat_survey_response_cnt,
    c.dsat_negative_survey_response_cnt, c.talk_duration_secs, c.acw_duration_secs, c.answer_hold_duration_secs,
    c.has_referral_gate, c.is_referred_externally,
    c.contact_subchannel_id, c.call_center_id, c.contact_start_ts, c.ticket_gate_level2_desc,
    c.ticket_gate_level0_desc, c.fact_utc_date, c.makegood_amt, c.makegood_cnt
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
on c1.contact_code = rcr.contact_code
