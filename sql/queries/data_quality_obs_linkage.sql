.headers on
.mode column

SELECT 'obs_total_raw' AS metric, COUNT(*) AS n FROM observations_raw;

SELECT 'obs_with_missing_encounter' AS metric,
       COUNT(*) AS n
FROM observations_raw r
LEFT JOIN encounters e ON e.Id = TRIM(r.ENCOUNTER)
WHERE TRIM(COALESCE(r.ENCOUNTER,'')) != ''
  AND e.Id IS NULL;

SELECT 'obs_patient_encounter_mismatch' AS metric,
       COUNT(*) AS n
FROM observations_raw r
JOIN encounters e ON e.Id = TRIM(r.ENCOUNTER)
WHERE TRIM(COALESCE(r.ENCOUNTER,'')) != ''
  AND TRIM(COALESCE(r.PATIENT,'')) != ''
  AND e.PATIENT != TRIM(r.PATIENT);

SELECT 'obs_missing_patient' AS metric,
       COUNT(*) AS n
FROM observations_raw
WHERE TRIM(COALESCE(PATIENT,'')) = '';

SELECT 'obs_missing_date' AS metric,
       COUNT(*) AS n
FROM observations_raw
WHERE TRIM(COALESCE(DATE,'')) = '';
