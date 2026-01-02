.headers on
.mode column

SELECT
  substr(START, 1, 7) AS year_month,
  COUNT(*) AS encounters
FROM encounters
WHERE START IS NOT NULL AND START != ''
GROUP BY year_month
ORDER BY year_month;

SELECT
  c.DESCRIPTION,
  COUNT(DISTINCT c.ENCOUNTER) AS n_encounters
FROM conditions c
WHERE TRIM(COALESCE(c.DESCRIPTION,'')) != ''
GROUP BY c.DESCRIPTION
ORDER BY n_encounters DESC
LIMIT 20;
