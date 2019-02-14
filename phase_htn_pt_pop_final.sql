SELECT Count (DISTINCT person.person_id), pt_max_enc_date_loc.location_id
FROM person
INNER JOIN patient_encounter ON patient_encounter.person_id = person.person_id
INNER JOIN patient_diagnosis ON patient_diagnosis.enc_id = patient_encounter.enc_id
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
		AND (person.first_name not like '%test%' OR person.last_name not like '%test%')
		AND DATEDIFF(YEAR,person.date_of_birth, patient_encounter.billable_timestamp)>= 18
		AND DATEDIFF (yy, CAST (person.date_of_birth as DATETIME), '2018-03-31') <= 85 
		GROUP BY person.person_id ) pt_max_enc_date ON pt_max_enc_date.person_id = person.person_id AND pt_max_enc_date.max_enc_date = patient_encounter.billable_timestamp
	) pt_max_enc_date_loc  ON pt_max_enc_date_loc.person_id = person.person_id
WHERE  (patient_diagnosis.diagnosis_code_id = 'I10' and DATEDIFF(mm, '2017-04-01', patient_diagnosis.create_timestamp) <=6)
AND (patient_diagnosis.create_timestamp NOT BETWEEN '2017-04-01' AND '2018-03-31' AND patient_diagnosis.diagnosis_code_id NOT in ('N18.6', 'Z94.0', 'Z3A.35', 'Z3A.18', 'Z3A.08', 'Z34.93', 'Z34.92', 'Z34.91', 'Z34.90', 'Z34.83', 'Z34.82', 'Z34.81', 'Z34.80', 'Z34.03', 'Z34.02', 'Z34.01', 'Z34.00', 'Z33.1', 'Z32.02', 'Z32.01', 'O99.89', 'O99.89', 'O99.810', 'O99.340', 'O99.331', 'O99.280', 'O99.019', 'O99.013', 'O99.012', 'O98.419', 'O40.9XX0', 'O32.1XX9', 'O26.892', 'O26.891', 'O26.86', 'O26.03', 'O26.00', 'O24.911', 'O24.419', 'O23.43', 'O20.9', 'O16.5', 'O16.2', 'O13.3', 'O12.03', 'O09.892', 'N96', 'O09.212', 'O09.291', 'O09.31', 'O09.891'))
GROUP BY pt_max_enc_date_loc.location_id