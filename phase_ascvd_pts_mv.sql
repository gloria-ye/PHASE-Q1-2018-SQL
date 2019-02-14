SELECT COUNT (DISTINCT person.person_id) number_of_ascvd_pts_ma
FROM person
INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
INNER JOIN 
	(SELECT DISTINCT person.person_id, MAX (patient_encounter.create_timestamp) max_enc_date
	FROM person
	INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
	INNER JOIN patient_diagnosis ON patient_diagnosis.enc_id = patient_encounter.enc_id
	WHERE patient_encounter.create_timestamp BETWEEN '2017-04-01' AND '2018-03-31'
	AND (patient_diagnosis.diagnosis_code_id like 'I21%'
		OR patient_diagnosis.diagnosis_code_id like 'I22%'
		OR patient_diagnosis.diagnosis_code_id like 'I23%'
		OR patient_diagnosis.diagnosis_code_id like 'I20%'
		OR patient_diagnosis.diagnosis_code_id like 'I24%'
		OR patient_diagnosis.diagnosis_code_id like 'I63%'
		OR patient_diagnosis.diagnosis_code_id like 'I65%'
		OR patient_diagnosis.diagnosis_code_id like 'I70%'
		OR patient_diagnosis.diagnosis_code_id in ('I25.2', 'Z95.1', 'I25.1', 'I25.5', '125.6', '125.7', '125.8', '125.9', '167.2'))
	GROUP BY person.person_id) pt_max_enc_date
ON pt_max_enc_date.person_id = person.person_id AND pt_max_enc_date.max_enc_date = patient_encounter.create_timestamp
WHERE patient_encounter.location_id in ('1B7C644F-57CB-44A9-BA73-FE663C067D5E', '8250AA0C-BCF3-42CB-9338-ED25F1049571')