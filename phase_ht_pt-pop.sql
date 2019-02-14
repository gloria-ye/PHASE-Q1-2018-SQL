SELECT COUNT (DISTINCT person.person_id)
FROM person
INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
INNER JOIN patient_diagnosis ON patient_diagnosis.enc_id = patient_encounter.enc_id
WHERE DATEDIFF (yy, CAST (person.date_of_birth as DATETIME), '2018-03-31') >= 18
AND DATEDIFF (yy, CAST (person.date_of_birth as DATETIME), '2018-03-31') <= 85 
AND patient_diagnosis.diagnosis_code_id = 'I10'
AND patient_encounter.create_timestamp BETWEEN '2017-04-01' AND DATEADD (mm, +6, '2017-04-01')
