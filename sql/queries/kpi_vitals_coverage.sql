.headers on
.mode column

-- Top observation concepts by frequency
SELECT
  DESCRIPTION,
  UNITS,
  COUNT(*) AS n
FROM observations
WHERE TRIM(COALESCE(DESCRIPTION,'')) != ''
GROUP BY DESCRIPTION, UNITS
ORDER BY n DESC
LIMIT 20;

-- Encounter-level vitals coverage (using keywords)
WITH enc AS (
  SELECT Id FROM encounters
),
obs AS (
  SELECT
    ENCOUNTER,
    LOWER(COALESCE(DESCRIPTION,'')) AS desc_l,
    LOWER(COALESCE(TYPE,'')) AS type_l
  FROM observations
  WHERE TRIM(COALESCE(ENCOUNTER,'')) != ''
),
flags AS (
  SELECT
    ENCOUNTER,
    MAX(CASE WHEN desc_l LIKE '%systolic%' OR desc_l LIKE '%diastolic%' OR desc_l LIKE '%blood pressure%' THEN 1 ELSE 0 END) AS has_bp,
    MAX(CASE WHEN desc_l LIKE '%heart rate%' OR desc_l LIKE '%pulse%' THEN 1 ELSE 0 END) AS has_hr,
    MAX(CASE WHEN desc_l LIKE '%body temperature%' OR desc_l LIKE '%temperature%' THEN 1 ELSE 0 END) AS has_temp,
    MAX(CASE WHEN desc_l LIKE '%respiratory rate%' THEN 1 ELSE 0 END) AS has_rr,
    MAX(CASE WHEN desc_l LIKE '%oxygen saturation%' OR desc_l LIKE '%spo2%' THEN 1 ELSE 0 END) AS has_spo2
  FROM obs
  GROUP BY ENCOUNTER
)
SELECT
  (SELECT COUNT(*) FROM encounters) AS total_encounters,
  SUM(has_bp) AS encounters_with_bp,
  ROUND(1.0 * SUM(has_bp) / (SELECT COUNT(*) FROM encounters), 4) AS bp_coverage,
  SUM(has_hr) AS encounters_with_hr,
  ROUND(1.0 * SUM(has_hr) / (SELECT COUNT(*) FROM encounters), 4) AS hr_coverage,
  SUM(has_temp) AS encounters_with_temp,
  ROUND(1.0 * SUM(has_temp) / (SELECT COUNT(*) FROM encounters), 4) AS temp_coverage,
  SUM(has_rr) AS encounters_with_rr,
  ROUND(1.0 * SUM(has_rr) / (SELECT COUNT(*) FROM encounters), 4) AS rr_coverage,
  SUM(has_spo2) AS encounters_with_spo2,
  ROUND(1.0 * SUM(has_spo2) / (SELECT COUNT(*) FROM encounters), 4) AS spo2_coverage
FROM flags;
