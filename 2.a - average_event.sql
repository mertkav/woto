WITH
  user_event_counts AS (
  SELECT
    user_id,
    COUNT(*) AS event_count
  FROM
    dataset.data_table
  GROUP BY
    user_id )
SELECT
  AVG(event_count) AS average_event_count,
  APPROX_QUANTILES(event_count, 2)[
OFFSET
  (1)] AS median_event_count,
  APPROX_QUANTILES(event_count, 4)[
OFFSET
  (1)] AS percentile_25_event_count,
  APPROX_QUANTILES(event_count, 4)[
OFFSET
  (3)] AS percentile_75_event_count
FROM
  user_event_counts;