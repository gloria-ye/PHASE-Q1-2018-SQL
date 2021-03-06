SELECT COUNT (DISTINCT person.person_id) number_of_ascvd_pts/*, MAX (patient_encounter.create_timestamp) max_enc_date*/
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
/* GROUP BY person.person_id */