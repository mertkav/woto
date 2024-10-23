  -- 1. Determine the most frequently played memes, unique_plays and_play_per_user
SELECT
  event_name AS meme,
  COUNT(*) AS play_count,
  COUNT(DISTINCT user_id) AS unique_user_play,
  COUNT(user_id)/ COUNT(DISTINCT user_id) AS play_per_user
FROM
  dataset.data_table
GROUP BY
  event_name
ORDER BY
  play_count DESC
LIMIT
  50;

-- I divide event_time to event_day_hour format to group event_count
;

SELECT 
    CONCAT(CAST(TIMESTAMP(event_datetime) AS DATE), ' ', EXTRACT(HOUR FROM TIMESTAMP(event_datetime)), ':00') AS event_day_hour,
    COUNT(*) AS event_count
FROM 
    dataset.data_table
GROUP BY 
    event_day_hour
ORDER BY 
    event_day_hour;
