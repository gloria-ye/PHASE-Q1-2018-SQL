SELECT COUNT (DISTINCT person.person_id), pt_max_enc_date_loc.location_id
FROM person
INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
INNER JOIN depression_PHQ_9_ ON depression_PHQ_9_.person_id = patient_encounter.person_id
/* INNER JOIN assessment_impression_plan_ aip on aip.enc_id = patient_encounter.enc_id*/
INNER JOIN patient_diagnosis ON patient_diagnosis.enc_id = patient_encounter.enc_id
INNER JOIN referrals_order_ ON referrals_order_.enc_id = patient_encounter.enc_id
INNER JOIN
	(SELECT DISTINCT person.person_id, patient_encounter.location_id, patient_encounter.enc_id max_enc_id
	FROM person
	INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
	INNER JOIN
		(SELECT DISTINCT person.person_id, MAX(patient_encounter.billable_timestamp) max_enc_date
		FROM person
		INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
		WHERE patient_encounter.billable_timestamp >= '2017-04-01'
		AND patient_encounter.billable_timestamp <= '2018-03-31' 
		AND billable_ind = 'Y'
		AND person.first_name not like '%test%' OR person.last_name not like '%test%'
		AND DATEDIFF(YEAR,person.date_of_birth, patient_encounter.billable_timestamp)>= 12
		GROUP BY person.person_id ) pt_max_enc_date 
		ON pt_max_enc_date.person_id = person.person_id AND pt_max_enc_date.max_enc_date = patient_encounter.billable_timestamp
	) pt_max_enc_date_loc  ON pt_max_enc_date_loc.person_id = person.person_id AND pt_max_enc_date_loc.max_enc_id = patient_encounter.enc_id
WHERE patient_diagnosis.create_timestamp NOT BETWEEN '2017-04-01' AND '2018-03-31'
/* AND NOT (referrals_order_.actTextDisplay like '%psych%' or referrals_order_.actTextDisplay like '%Integrated Behavioral Health%')
AND patient_diagnosis.diagnosis_code_id NOT in ('296.20', '296.80', '296.80', '300.4', '309.0', '311', 'F32.0', 'F32.1', 'F32.1', 'F32.2', 'F32.3', 'F32.8', 'F32.89', 'F32.9', 'F33.0', 'F33.1', 'F33.2', 'F33.9', 'F34.1', 'F41.8', 'F41.9', 'F43.21', 'F43.23', 'F53', 'O99.340', 'O99.343', 'O99.345')
*/ AND depression_PHQ_9_.txt_total_score is NOT NULL
AND CAST (depression_PHQ_9_.encDate AS datetime) >= '2017-04-01'
AND CAST (depression_PHQ_9_.encDate AS datetime) <= '2018-03-31'
AND depression_PHQ_9_.txt_total_score < '10'
GROUP BY pt_max_enc_date_loc.location_id 

SELECT COUNT (DISTINCT person.person_id), pt_max_enc_date_loc.location_id
FROM person
INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
INNER JOIN depression_PHQ_9_ ON depression_PHQ_9_.person_id = patient_encounter.person_id
INNER JOIN assessment_impression_plan_ aip on aip.enc_id = patient_encounter.enc_id
INNER JOIN patient_diagnosis ON patient_diagnosis.enc_id = patient_encounter.enc_id
INNER JOIN referrals_order_ ON referrals_order_.enc_id = patient_encounter.enc_id
INNER JOIN
	(SELECT DISTINCT person.person_id, patient_encounter.location_id, patient_encounter.enc_id max_enc_id
	FROM person
	INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
	INNER JOIN
		(SELECT DISTINCT person.person_id, MAX(patient_encounter.billable_timestamp) max_enc_date
		FROM person
		INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
		WHERE patient_encounter.billable_timestamp >= '2017-04-01'
		AND patient_encounter.billable_timestamp <= '2018-03-31' 
		AND billable_ind = 'Y'
		AND person.first_name not like '%test%' OR person.last_name not like '%test%'
		AND DATEDIFF(YEAR,person.date_of_birth, patient_encounter.billable_timestamp)>= 12
		GROUP BY person.person_id ) pt_max_enc_date 
		ON pt_max_enc_date.person_id = person.person_id AND pt_max_enc_date.max_enc_date = patient_encounter.billable_timestamp
	) pt_max_enc_date_loc  ON pt_max_enc_date_loc.person_id = person.person_id AND pt_max_enc_date_loc.max_enc_id = patient_encounter.enc_id
WHERE depression_PHQ_9_.txt_total_score is NOT NULL
AND ( (patient_diagnosis.create_timestamp NOT BETWEEN '2017-04-01' AND '2018-03-31'
AND patient_diagnosis.diagnosis_code_id NOT in ('296.20', '296.80', '296.80', '300.4', '309.0', '311', 'F32.0', 'F32.1', 'F32.1', 'F32.2', 'F32.3', 'F32.8', 'F32.89', 'F32.9', 'F33.0', 'F33.1', 'F33.2', 'F33.9', 'F34.1', 'F41.8', 'F41.9', 'F43.21', 'F43.23', 'F53', 'O99.340', 'O99.343', 'O99.345')
)

OR ((referrals_order_.actTextDisplay like '%psych%' or referrals_order_.actTextDisplay like '%Integrated Behavioral Health%')
OR patient_diagnosis.diagnosis_code_id in ('V79.0','Z13.89')
OR (aip.txt_description like 'depression' or aip.txt_description like 'Momentum' or aip.txt_description like 'La Selva' or aip.txt_description like 'psych' or aip.txt_description like 'crisis line' or  aip.txt_description like 'mental health' or aip.txt_description like 'behavioral' or aip.txt_description like 'counseling'or aip.txt_description like'suicide' or aip.txt_description like '%depression%' or aip.txt_description like 'Carolyn' or aip.txt_description like 'Sasha' or aip.txt_description like 'Tonya' or aip.txt_description like 'SI' or aip.txt_description like 'psychiatry' or aip.txt_description like '%cutting%' or aip.txt_description like '%IBH%' or aip.txt_description like 'integrative behavioral health' or aip.txt_description like 'suicide attempt'))
)

AND CAST (depression_PHQ_9_.encDate AS datetime) >= '2017-04-01'
AND CAST (depression_PHQ_9_.encDate AS datetime) <= '2018-03-31'
AND DATEDIFF(YEAR,person.date_of_birth, depression_PHQ_9_.encDate)>= 12
AND patient_encounter.billable_timestamp >= '2017-04-01'
AND patient_encounter.billable_timestamp <= '2018-03-31' 
AND billable_ind = 'Y'
AND depression_PHQ_9_.txt_total_score >= '10'
GROUP BY pt_max_enc_date_loc.location_id 



