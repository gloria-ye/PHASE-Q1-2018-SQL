SELECT DISTINCT person.person_id 
FROM person
INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
INNER JOIN 	
	(SELECT DISTINCT person.person_id, MAX (patient_encounter.create_timestamp) as max_enc_date
	FROM person
	INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
	WHERE DATEDIFF (yy, CAST (person.date_of_birth as DATETIME), '2018-03-31') >= 18
	AND patient_encounter.create_timestamp BETWEEN '2017-04-01' AND '2018-03-31'
	AND billable_ind = 'Y'
	GROUP BY person.person_id) pt_max_enc_date
ON pt_max_enc_date.person_id = person.person_id 
AND pt_max_enc_date.max_enc_date = patient_encounter.create_timestamp
WHERE patient_encounter.location_id =  'DD0707A2-60AE-49EB-AF3B-DBDF032C4CC2'
GROUP BY person.person_id
	
