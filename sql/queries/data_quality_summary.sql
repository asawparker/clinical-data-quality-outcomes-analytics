.headers on
.mode column

-- Patients: key field completeness
SELECT
  'patients' AS table_name,
  SUM(CASE WHEN TRIM(COALESCE(Id,'')) = '' THEN 1 ELSE 0 END) AS missing_id,
  SUM(CASE WHEN TRIM(COALESCE(BIRTHDATE,'')) = '' THEN 1 ELSE 0 END) AS missing_birthdate,
  SUM(CASE WHEN TRIM(COALESCE(GENDER,'')) = '' THEN 1 ELSE 0 END) AS missing_gender,
  COUNT(*) AS total_rows
FROM patients;

-- Encounters: missing START/STOP
SELECT
  'encounters' AS table_name,
  SUM(CASE WHEN TRIM(COALESCE(Id,'')) = '' THEN 1 ELSE 0 END) AS missing_id,
  SUM(CASE WHEN TRIM(COALESCE(START,'')) = '' THEN 1 ELSE 0 END) AS missing_start,
  SUM(CASE WHEN TRIM(COALESCE(STOP,'')) = '' THEN 1 ELSE 0 END) AS missing_stop,
  COUNT(*) AS total_rows
FROM encounters;

-- Observations: missing core fields
SELECT
  'observations' AS table_name,
  SUM(CASE WHEN TRIM(COALESCE(DATE,'')) = '' THEN 1 ELSE 0 END) AS missing_date,
  SUM(CASE WHEN TRIM(COALESCE(PATIENT,'')) = '' THEN 1 ELSE 0 END) AS missing_patient,
  SUM(CASE WHEN TRIM(COALESCE(CODE,'')) = '' THEN 1 ELSE 0 END) AS missing_code,
  SUM(CASE WHEN TRIM(COALESCE(VALUE,'')) = '' THEN 1 ELSE 0 END) AS missing_value,
  COUNT(*) AS total_rows
FROM observations;

-- Encounters with at least 1 observation linked (coverage)
SELECT
  'encounters_with_observations' AS metric,
  COUNT(DISTINCT e.Id) AS n_encounters_with_obs,
  (SELECT COUNT(*) FROM encounters) AS total_encounters,
  ROUND(1.0 * COUNT(DISTINCT e.Id) / (SELECT COUNT(*) FROM encounters), 4) AS coverage
FROM encounters e
JOIN observations o ON o.ENCOUNTER = e.Id
WHERE TRIM(COALESCE(o.ENCOUNTER,'')) != '';
