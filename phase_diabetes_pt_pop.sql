SELECT COUNT (DISTINCT person.person_id) number_of_dm_pts /*, patient_diagnosis.diagnosis_code_id, patient_diagnosis.description, patient_encounter.billable_timestamp, person.date_of_birth */
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
AND DATEDIFF (yy, CAST (person.date_of_birth as DATE), '2018-03-31') >= 18
AND DATEDIFF (yy, CAST (person.date_of_birth as DATE), '2018-03-31') <= 75
/* GROUP BY patient_diagnosis.person_id, patient_diagnosis.diagnosis_code_id,  patient_diagnosis.description,  patient_encounter.billable_timestamp, person.date_of_birth */
HAVING COUNT (patient_encounter.billable_timestamp) >= 2

/* ORDER BY person.date_of_birth */