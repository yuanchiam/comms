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
-------------
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
-- temp table
-------------


select
    cf.contact_code,
    cf.call_center_id,
    cf.escalating_call_center_id,
    cf.bpo_contact_code,
    cf.gateway_contact_code,
    cf.first_ticket_id,
    cf.contact_start_ts,
    cf.contact_start_utc_ts,
    cf.contact_start_epoch_utc_ts,
    cf.contact_end_ts,
    cf.contact_end_utc_ts,
    cf.half_hour_code,
    cf.utc_half_hour_code,
    cf.account_id,
    cf.current_subscription_id,
    cf.current_plan_id,
    cf.has_dvd_plan,
    cf.member_type_desc,
    cf.customer_lookup_type,
    cf.contact_origin_country_code,
    cf.toll_free_nbr,
    cf.contact_subchannel_id,
    cf.chat_end_state_desc,
    cf.transfer_type_id,
    cf.gateway_duration_secs,
    cf.contact_skill_id,
    cf.bpo_start_ts,
    cf.bpo_start_utc_ts,
    cf.bpo_end_ts,
    cf.bpo_end_utc_ts,
    cf.contact_duration_secs,
    cf.bpo_duration_secs,
    cf.customer_queue_duration_secs,
    cf.customer_hold_duration_secs,
    cf.cust_msg_cnt,
    cf.agent_response_cnt,
    cf.agent_response_sec,
    cf.talk_duration_secs,
    cf.acw_duration_secs,
    cf.consult_duration_secs,
    cf.answer_hold_duration_secs,
    cf.gateway_cnt,
    cf.gateway_abandoned_cnt,
    cf.offerred_to_bpo_cnt,
    cf.bpo_switch_cnt,
    cf.bpo_switch_abandoned_cnt,
    cf.bpo_skill_cnt,
    cf.bpo_skill_abandoned_cnt,
    cf.answered_cnt,
    cf.answered_in_sla_cnt,
    cf.abandoned_in_sla_cnt,
    cf.has_service_code_cnt,
    cf.outbound_contact_cnt,
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
    cf.ticket_resolution_gate_desc,
    cf.survey_question_id,
    cf.survey_cnt,
    cf.survey_response_cnt,
    cf.dsat_survey_response_cnt,
    cf.negative_survey_response_cnt,
    cf.dsat_negative_survey_response_cnt,
    cf.ticket_cnt,
    cf.makegood_amt,
    cf.makegood_cnt,
    cf.makegood_ticket_cnt,
    cf.vesn,
    cf.device_type_id,
    cf.device_model_id,
    cf.device_client_ver,
    cf.agent_role_code,
    cf.chewbacca_user_id,
    cf.supervisor_chewbacca_user_id,
    cf.manager_chewbacca_user_id,
    cf.member_ticket_cnt,
    cf.member_ticket_with_cust_msg_cnt,
    cf.kb_articles_used_cnt,
    cf.kb_search_cnt,
    cf.has_referral_gate,
    cf.is_referred_externally,
    cf.is_assistance_requested,
    cf.is_secondary_skill_contact,
    cf.fact_date,
    cf.fact_utc_date
from dse.cs_contact_f cf
where cf.fact_utc_date>20170101
