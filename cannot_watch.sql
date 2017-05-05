select 
  c.call_center_id,
  c.account_id, 
  c.member_type_desc,
  c.contact_origin_country_code,
  c.contact_subchannel_id,
  c.contact_skill_id,
  c.ticket_gate_level0_desc,
  c.ticket_gate_level1_desc,
  c.ticket_gate_level2_desc,
  c.ticket_gate_level3_desc,
  c.dsat_survey_response_cnt,
  c.dsat_negative_survey_response_cnt,
  c.vesn, 
  c.device_type_id, 
  c.device_model_id, 
  c.device_client_ver, 
  c.kb_article_used_cnt,
  c.fact_utc_date,
  case when c.ticket_gate_level0_desc='Can''t Watch' then 1 else 0 end as cw_flag
from dse.cs_contact_f c
join dse.cs_transfer_type_d trt on c.transfer_type_id = trt.transfer_type_id
join dse.cs_contact_skill_d r on r.contact_skill_id=c.contact_skill_id
join dse.cs_call_center_d dc on dc.call_center_id=c.call_center_id 
where c.fact_utc_date >=20170101    
--always include these extra filters to remove research and escalated tickets or your numbers will be inflated
and r.escalation_code not in ('G-Escalation', 'SC-Consult','SC-Escalation','Corp-Escalation')
and trt.major_transfer_type_desc not in ('TRANSFER_OUT')
and c.answered_cnt>0
and c.contact_subchannel_id in ('Phone', 'Chat', 'voip','InApp', 'MBChat')

-- Aggregate

select 
  c.call_center_id,
  count(c.account_id) num_contacts, 
  c.member_type_desc,
  c.contact_origin_country_code,
  c.contact_subchannel_id,
  c.contact_skill_id,
  c.ticket_gate_level0_desc,
  c.ticket_gate_level1_desc,
  c.ticket_gate_level2_desc,
  c.ticket_gate_level3_desc,
  c.dsat_survey_response_cnt,
  c.dsat_negative_survey_response_cnt,
  c.vesn, 
  c.device_type_id, 
  c.device_model_id, 
  c.device_client_ver, 
  c.kb_articles_used_cnt,
  c.fact_utc_date,
  case when c.ticket_gate_level0_desc='Can''t Watch' then 1 else 0 end as flag
from dse.cs_contact_f c
join dse.cs_transfer_type_d trt on c.transfer_type_id = trt.transfer_type_id
join dse.cs_contact_skill_d r on r.contact_skill_id=c.contact_skill_id
join dse.cs_call_center_d dc on dc.call_center_id=c.call_center_id 
where c.fact_utc_date >=20170101    
--always include these extra filters to remove research and escalated tickets or your numbers will be inflated
and r.escalation_code not in ('G-Escalation', 'SC-Consult','SC-Escalation','Corp-Escalation')
and trt.major_transfer_type_desc not in ('TRANSFER_OUT')
and c.answered_cnt>0
and c.contact_subchannel_id in ('Phone', 'Chat', 'voip','InApp', 'MBChat')
group by c.call_center_id,
  c.member_type_desc,
  c.contact_origin_country_code,
  c.contact_subchannel_id,
  c.contact_skill_id,
  c.ticket_gate_level0_desc,
  c.ticket_gate_level1_desc,
  c.ticket_gate_level2_desc,
  c.ticket_gate_level3_desc,
  c.dsat_survey_response_cnt,
  c.dsat_negative_survey_response_cnt,
  c.vesn, 
  c.device_type_id, 
  c.device_model_id, 
  c.device_client_ver, 
  c.kb_articles_used_cnt,
  c.fact_utc_date,
  case when c.ticket_gate_level0_desc='Can''t Watch' then 1 else 0 end
