WITH
  user_event_counts AS (

  SELECT
    user_id,
    COUNT(*) AS event_count
  FROM
    dataset.data_table
  GROUP BY
    user_id ),
  percentiles AS (

  SELECT
    PERCENTILE_CONT(event_count, 0.25) OVER () AS low_threshold,
    PERCENTILE_CONT(event_count, 0.75) OVER () AS high_threshold
  FROM
    user_event_counts ),
  classified_users AS (
    -- Classify users based on thresholds
  SELECT
    DISTINCT u.user_id,
    u.event_count,
    CASE
      WHEN u.event_count < p.low_threshold THEN 'low_engaged'
      WHEN u.event_count >= p.low_threshold
    AND u.event_count <= p.high_threshold THEN 'middle_engaged'
      ELSE 'high_engaged'
  END
    AS engagement_level
  FROM
    user_event_counts u,
    percentiles p )
  -- Select unique classified users
SELECT
  *
FROM
  classified_users
ORDER BY
  event_count DESC;