select count (distinct person.person_id)
FROM person
INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
INNER JOIN 
	(SELECT person.person_id, MAX (patient_encounter.create_timestamp) as max_enc_date
	/* , CAST (person.date_of_birth as DATETIME), DATEDIFF (yy, CAST (person.date_of_birth as DATETIME), '2018-03-31'), patient_diagnosis.diagnosis_code_id, patient_encounter.create_timestamp */
	FROM person
	INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
	INNER JOIN patient_diagnosis ON patient_diagnosis.enc_id = patient_encounter.enc_id
	WHERE DATEDIFF (yy, CAST (person.date_of_birth as DATETIME), '2018-03-31') >= 18
	AND DATEDIFF (yy, CAST (person.date_of_birth as DATETIME), '2018-03-31') <= 85 
	AND patient_diagnosis.diagnosis_code_id = 'I10'
	AND patient_encounter.create_timestamp BETWEEN '2017-04-01' AND DATEADD (mm, +6, '2017-04-01')
	GROUP BY person.person_id) pt_max_enc_date 
ON pt_max_enc_date.person_id = person.person_id AND pt_max_enc_date.max_enc_date = patient_encounter.create_timestamp
WHERE patient_encounter.location_id in ('DD0707A2-60AE-49EB-AF3B-DBDF032C4CC2')

/* Palo Alto: '9D971E61-2B5A-4504-9016-7FD863790EE2' 
MV: '1B7C644F-57CB-44A9-BA73-FE663C067D5E' or '8250AA0C-BCF3-42CB-9338-ED25F1049571'
CNC: 'DD0707A2-60AE-49EB-AF3B-DBDF032C4CC2'
MV Lab: '356B6E71-7387-4044-97BA-5487513854E1'
CNC Lab: '32E0E77B-EEC4-4060-9512-4A3596543DCF'
PA Lab: 'F00F93BD-AB8F-436D-92B3-C798E2CDDAA0'
*/