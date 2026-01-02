.headers on
.mode column

-- How many observations have numeric-looking values?
SELECT
  SUM(CASE WHEN VALUE GLOB '*[0-9]*' THEN 1 ELSE 0 END) AS value_has_digit,
  SUM(CASE WHEN TRIM(COALESCE(VALUE,'')) = '' THEN 1 ELSE 0 END) AS value_missing,
  COUNT(*) AS total_observations
FROM observations;

-- Units coverage (missing units can be a real issue)
SELECT
  SUM(CASE WHEN TRIM(COALESCE(UNITS,'')) = '' THEN 1 ELSE 0 END) AS missing_units,
  COUNT(*) AS total_observations,
  ROUND(1.0 * SUM(CASE WHEN TRIM(COALESCE(UNITS,'')) = '' THEN 1 ELSE 0 END) / COUNT(*), 4) AS missing_units_rate
FROM observations;

-- Most common non-numeric VALUE strings (useful to show data cleaning needed)
SELECT
  VALUE,
  COUNT(*) AS n
FROM observations
WHERE TRIM(COALESCE(VALUE,'')) != ''
  AND VALUE NOT GLOB '*[0-9]*'
GROUP BY VALUE
ORDER BY n DESC
LIMIT 20;

-- Example: values that are suspiciously high/low for common vitals (heuristic)
-- This won’t be perfect, but it demonstrates analyst thinking.
SELECT
  DESCRIPTION,
  UNITS,
  COUNT(*) AS n,
  MIN(CASE WHEN VALUE GLOB '*[0-9]*' THEN CAST(VALUE AS REAL) END) AS min_numeric,
  MAX(CASE WHEN VALUE GLOB '*[0-9]*' THEN CAST(VALUE AS REAL) END) AS max_numeric
FROM observations
WHERE LOWER(COALESCE(DESCRIPTION,'')) LIKE '%heart rate%'
   OR LOWER(COALESCE(DESCRIPTION,'')) LIKE '%body temperature%'
   OR LOWER(COALESCE(DESCRIPTION,'')) LIKE '%oxygen saturation%'
GROUP BY DESCRIPTION, UNITS
ORDER BY n DESC
LIMIT 30;
