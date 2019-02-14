SELECT DISTINCT person.person_id
FROM person
INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
INNER JOIN depression_PHQ_9_ ON depression_PHQ_9_.enc_id = patient_encounter.enc_id
INNER JOIN assessment_impression_plan_ aip on aip.enc_id = patient_encounter.enc_id
WHERE depression_PHQ_9_.txt_total_score is NOT NULL
AND (aip.txt_description like 'depression' or aip.txt_description like 'Momentum' or aip.txt_description like 'La Selva' or aip.txt_description like 'psych' or aip.txt_description like 'crisis line' or  aip.txt_description like 'mental health' or aip.txt_description like 'behavioral' or aip.txt_description like 'counseling'or aip.txt_description like'suicide' or aip.txt_description like '%depression%' or aip.txt_description like 'Carolyn' or aip.txt_description like 'Sasha' or aip.txt_description like 'Tonya' or aip.txt_description like 'SI' or aip.txt_description like 'psychiatry' or aip.txt_description like '%cutting%' or aip.txt_description like '%IBH%' or aip.txt_description like 'integrative behavioral health' or aip.txt_description like 'suicide attempt')
AND CAST (depression_PHQ_9_.encDate AS datetime) >= '2017-04-01'
AND CAST (depression_PHQ_9_.encDate AS datetime) <= '2018-03-31'
AND DATEDIFF(YEAR,person.date_of_birth, depression_PHQ_9_.encDate)>= 12
AND patient_encounter.billable_timestamp >= '2017-04-01'
AND patient_encounter.billable_timestamp <= '2018-03-31' 
AND billable_ind = 'Y'
AND depression_PHQ_9_.txt_total_score >= '9'
AND person.first_name not like '%test%' OR person.last_name not like '%test%'
AND patient_encounter.location_id = '9D971E61-2B5A-4504-9016-7FD863790EE2'
UNION
SELECT DISTINCT person.person_id
FROM person
INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
INNER JOIN depression_PHQ_9_ ON depression_PHQ_9_.enc_id = patient_encounter.enc_id
INNER JOIN assessment_impression_plan_ aip on aip.enc_id = patient_encounter.enc_id
WHERE depression_PHQ_9_.txt_total_score is NOT NULL
AND CAST (depression_PHQ_9_.encDate AS datetime) >= '2017-04-01'
AND CAST (depression_PHQ_9_.encDate AS datetime) <= '2018-03-31'
AND patient_encounter.billable_timestamp >= '2017-04-01'
AND patient_encounter.billable_timestamp <= '2018-03-31' 
AND DATEDIFF(YEAR,person.date_of_birth, depression_PHQ_9_.encDate)>= 12 
AND billable_ind = 'Y'
AND depression_PHQ_9_.txt_total_score < '9'
AND person.first_name not like '%test%' OR person.last_name not like '%test%'
AND patient_encounter.location_id = '9D971E61-2B5A-4504-9016-7FD863790EE2'

/* Palo Alto: '9D971E61-2B5A-4504-9016-7FD863790EE2' 
MV: '1B7C644F-57CB-44A9-BA73-FE663C067D5E' or '8250AA0C-BCF3-42CB-9338-ED25F1049571'
CNC: 'DD0707A2-60AE-49EB-AF3B-DBDF032C4CC2'
MV Lab: '356B6E71-7387-4044-97BA-5487513854E1'
CNC Lab: '32E0E77B-EEC4-4060-9512-4A3596543DCF'
PA Lab: 'F00F93BD-AB8F-436D-92B3-C798E2CDDAA0'
*/