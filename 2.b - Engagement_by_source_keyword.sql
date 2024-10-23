WITH
  user_event_counts AS (
    -- Calculate the number of events per user
  SELECT
    user_id,
    source_keyword,
    COUNT(*) AS event_count
  FROM
    dataset.data_table
  GROUP BY
    user_id,
    source_keyword ),
  percentiles AS (
    --
  SELECT
    PERCENTILE_CONT(event_count, 0.25) OVER () AS low_threshold,
    PERCENTILE_CONT(event_count, 0.75) OVER () AS high_threshold
  FROM
    user_event_counts ),
  classified_users AS (
    --
  SELECT
    DISTINCT u.user_id,
    u.source_keyword,
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
  -- Group by source_keyword and its engagement
SELECT
  source_keyword,
  engagement_level,
  COUNT(*) AS user_count,
  MAX(event_count) AS max_event_count,
  MIN(event_count) AS min_event_count
FROM
  classified_users
GROUP BY
  source_keyword,
  engagement_level
ORDER BY
  source_keyword,
  engagement_level;