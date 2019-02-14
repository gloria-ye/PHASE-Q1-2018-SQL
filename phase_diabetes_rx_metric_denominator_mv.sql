SELECT  COUNT (DISTINCT person.person_id)number_of_dm_pts_mv
FROM person
INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
INNER JOIN 
	(SELECT DISTINCT person.person_id, MAX(patient_encounter.billable_timestamp) max_billable_enc_date/*, patient_diagnosis.diagnosis_code_id, patient_diagnosis.description, patient_encounter.billable_timestamp, person.date_of_birth */
	FROM person
	INNER JOIN patient_encounter on patient_encounter.person_id = person.person_id
	INNER JOIN patient_diagnosis on patient_diagnosis.enc_id = patient_encounter.enc_id
	WHERE (patient_diagnosis.diagnosis_code_id like 'E10%' 
		   OR patient_diagnosis.diagnosis_code_id like 'E11%'
		   OR patient_diagnosis.diagnosis_code_id like 'E13%'
		   OR patient_diagnosis.diagnosis_code_id in ('O24.0', 'O24.1' , 'O24.3' , 'O24.8'))
	AND patient_encounter.billable_timestamp >= '2017-04-01' 
	AND patient_encounter.billable_timestamp <= '2018-03-31'
	AND patient_encounter.billable_ind = 'Y'
	AND DATEDIFF (yy, CAST (person.date_of_birth as DATE), '2018-03-31') >= 55
	AND DATEDIFF (yy, CAST (person.date_of_birth as DATE), '2018-03-31') <= 75
	GROUP BY person.person_id /* , patient_diagnosis.diagnosis_code_id,  patient_diagnosis.description,  patient_encounter.billable_timestamp, person.date_of_birth */
	HAVING COUNT (patient_encounter.billable_timestamp) >= 2) pt_max_enc_date 
ON pt_max_enc_date.person_id = person.person_id AND pt_max_enc_date.max_billable_enc_date = patient_encounter.billable_timestamp
WHERE patient_encounter.location_id in ('1B7C644F-57CB-44A9-BA73-FE663C067D5E', '8250AA0C-BCF3-42CB-9338-ED25F1049571')