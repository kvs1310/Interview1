Use synpuf52_fixed;
--CDM & vocabulary version 
SELECT cdm_version,vocabulary_version
FROM cdm_source;

--Non-standard Concept ID from other vocabularies for ICD10 code ‘I48.0’
SELECT concept_id FROM dbo.concept
WHERE concept_code = 'I48.0';

--Drug products containing active ingredient 'Epoetin Alfa' ( RxNorm code: 105694)
SELECT * FROM dbo.concept
WHERE concept_code = '105694';

--All concept relationships for concept code 105694
SELECT * FROM concept_relationship AS A, dbo.concept AS B
WHERE A.concept_id_1 = B.concept_id AND B.concept_code = '105694';

--Patients suffering from ‘Anemia’ condition
SELECT DISTINCT person_id FROM condition_era AS A, dbo.concept AS B
WHERE A.condition_concept_id= B.concept_id and B.concept_name LIKE '%Anemia%' ;

--Total no. of male/female patients ASSUMING 8507 as FEMALE and 8532 as MALE
SELECT COUNT(CASE WHEN gender_concept_id = '8507' THEN 1 END) AS FEMALE,COUNT(CASE WHEN gender_concept_id = '8532' THEN 1 END) AS MALE FROM person;

--Patients having observation period between 01-01-2009 and 31-12-2010
SELECT DISTINCT person_id FROM observation_period WHERE observation_period_start_date > '2009-01-01' AND observation_period_end_date < '2010-12-31';




--patients who did ‘Dialysis procedure’ gathered from given datascource(website) that Dialyis Procedure's concept_id is 4032243
SELECT DISTINCT person_id FROM procedure_occurrence WHERE procedure_concept_id = '4032243';


--Providers who did ‘Dialysis procedure’ in descending order. 
SELECT DISTINCT provider_id FROM procedure_occurrence WHERE procedure_concept_id = '4032243' ORDER BY provider_id DESC;


--Patients who are 'Epoetin Alfa' drug users & are suffering from 'Anemia' and have visit start date between 01-01-2009 and 31-12-2010. 
SELECT DISTINCT person_id FROM observation_period WHERE observation_period_start_date >= '2009-01-01' 
AND observation_period_end_date <= '2010-12-31' AND person_id in 
(SELECT DISTINCT A.person_id FROM condition_era AS A, dbo.concept AS B
WHERE A.condition_concept_id= B.concept_id and B.concept_name LIKE '%Anemia%'
And A.condition_concept_id in 
(SELECT A.concept_id_1 FROM concept_relationship AS A, dbo.concept AS B
WHERE A.concept_id_1 = B.concept_id AND B.concept_code = '105694')) 


