WITH user_event_counts AS (
  -- Calculateing the number of events per user
  SELECT 
    user_id, 
    COUNT(*) AS event_count
  FROM 
    `dataset.data_table`
  GROUP BY 
    user_id
),

percentiles AS (
  -- Calculateing the low,mid and high segments
  SELECT 
    PERCENTILE_CONT(event_count, 0.25) OVER () AS low_segments,
    PERCENTILE_CONT(event_count, 0.75) OVER () AS high_segments
  FROM 
    user_event_counts
),

classified_users AS (
  -- Classify users based on the calculated segmentss
  SELECT 
    u.user_id, 
    u.event_count,
    CASE 
      WHEN u.event_count < p.low_segments THEN 'low_engaged'
      WHEN u.event_count >= p.low_segments AND u.event_count <= p.high_segments THEN 'middle_engaged'
      ELSE 'high_engaged'
    END AS engagement_level
  FROM 
    user_event_counts u, 
    percentiles p
)

-- the count of max, and min for each engagement level
SELECT 
  engagement_level,
  COUNT(distinct user_id) AS user_count,
  MAX(event_count) AS max_event_count,
  MIN(event_count) AS min_event_count
FROM 
  classified_users
GROUP BY 
  engagement_level
ORDER BY 
  max_event_count;
