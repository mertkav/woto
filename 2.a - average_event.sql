WITH
  user_event_counts AS (
  SELECT
    user_id,
    COUNT(*) AS event_count
  FROM
    dataset.data_table
  GROUP BY
    user_id ),
  percentile_calculations AS (
  SELECT
    event_count,
    PERCENT_RANK() OVER (ORDER BY event_count) AS percentile_rank
  FROM
    user_event_counts )
SELECT
  SUM(event_count) AS total_event_count,
  AVG(event_count) AS average_event_count,
  (
  SELECT
    event_count
  FROM
    percentile_calculations
  WHERE
    percentile_rank >= 0.50
  ORDER BY
    percentile_rank
  LIMIT
    1) AS median_event_count,
  (
  SELECT
    event_count
  FROM
    percentile_calculations
  WHERE
    percentile_rank >= 0.25
  ORDER BY
    percentile_rank
  LIMIT
    1) AS percentile_25_event_count,
  (
  SELECT
    event_count
  FROM
    percentile_calculations
  WHERE
    percentile_rank >= 0.75
  ORDER BY
    percentile_rank
  LIMIT
    1) AS percentile_75_event_count,
  AVG(CASE
      WHEN percentile_rank >= 0.05 AND percentile_rank <= 0.95 THEN event_count
  END
    ) AS average_excluding_5th_95th_percentile
FROM
  percentile_calculations;
