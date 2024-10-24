  -- Determine the most frequently played memes, unique_plays and_play_per_user
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

-- I divide event_time format only hours
;

SELECT 
    FORMAT_TIMESTAMP('%Y-%m-%d %H:00:00', TIMESTAMP(event_datetime)) AS event_datetime,
    COUNT(*) AS event_count
FROM 
    dataset.data_table
GROUP BY 
    event_datetime
ORDER BY 
    event_datetime;
