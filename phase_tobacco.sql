/* select distinct txt_tobacco_use_status, * from tobacco_usage_ 


/* Patients who were screened for tobacco use at least once within 24 months of the most recent visit
and who received tobacco cessation intervention if identified as a tobacco user.*/

SELECT DISTINCT txt_tobacco_cessation_code, txt_tobacco_cessation_discuss, tobacco_cessation_discuss_.create_timestamp, *
FROM tobacco_cessation_discuss_ 
where create_timestamp BETWEEN '2017-04-01' AND '2018-03-31'
*/

SELECT DISTINCT person.person_id /*, tobacco_usage_.txt_tobacco_use_status, txt_tobacco_cessation_code, CAST (tobacco_usage_.enc_date as DATE) tobacco_usage_enc_date, pt_max_enc_date.max_enc_date */
FROM person
INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
INNER JOIN patient_diagnosis ON patient_diagnosis.enc_id = patient_encounter.enc_id
INNER JOIN tobacco_usage_ ON tobacco_usage_.person_id = patient_encounter.person_id
INNER JOIN tobacco_cessation_discuss_ ON tobacco_cessation_discuss_.person_id = patient_encounter.person_id
INNER JOIN	
	(SELECT DISTINCT person.person_id, MAX (patient_encounter.create_timestamp) as max_enc_date
	FROM person
	INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
	WHERE DATEDIFF (yy, CAST (person.date_of_birth as DATETIME), '2018-03-31') >= 18
	AND patient_encounter.create_timestamp BETWEEN '2017-04-01' AND '2018-03-31'
	AND billable_ind = 'Y'
	GROUP BY person.person_id) pt_max_enc_date 
ON pt_max_enc_date.person_id = person.person_id 
	AND DATEDIFF (mm, tobacco_usage_.enc_date, pt_max_enc_date.max_enc_date)<= 24
	AND pt_max_enc_date.max_enc_date = patient_encounter.create_timestamp
WHERE DATEDIFF (yy, CAST (person.date_of_birth as DATETIME), '2018-03-31') >= 18
AND (tobacco_usage_.txt_tobacco_use_status = 'no/never' 
	OR (tobacco_usage_.txt_tobacco_use_status = 'yes'
		AND (patient_diagnosis.diagnosis_code_id = 'Z71.6'
			OR txt_tobacco_cessation_code in ('315232003', '225324006', '225323000')
			)
		)
	)
GROUP BY person.person_id

/* Palo Alto: '9D971E61-2B5A-4504-9016-7FD863790EE2' 
MV: '1B7C644F-57CB-44A9-BA73-FE663C067D5E' or '8250AA0C-BCF3-42CB-9338-ED25F1049571'
CNC: 'DD0707A2-60AE-49EB-AF3B-DBDF032C4CC2'
MV Lab: '356B6E71-7387-4044-97BA-5487513854E1'
CNC Lab: '32E0E77B-EEC4-4060-9512-4A3596543DCF'
PA Lab: 'F00F93BD-AB8F-436D-92B3-C798E2CDDAA0'
*/