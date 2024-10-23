WITH
  user_events AS (
  SELECT
    user_id,
    country,
    create_datetime,
    event_datetime,
    DATE(create_datetime) AS account_creation_date,
    DATE(event_datetime) AS event_date
  FROM
    dataset.data_table ),
  -- Calculate D1,D2,D3 retained users using create_datetime and event_date
  retention_metrics AS (
  SELECT
    user_id,
    country,
    -- Calculation d1,d2,d3 retained users
    COUNT(DISTINCT
      CASE
        WHEN DATE_DIFF(event_date, account_creation_date, DAY) = 1 THEN user_id
    END
      ) AS d1_retained,
    COUNT(DISTINCT
      CASE
        WHEN DATE_DIFF(event_date, account_creation_date, DAY) = 2 THEN user_id
    END
      ) AS d2_retained,
    COUNT(DISTINCT
      CASE
        WHEN DATE_DIFF(event_date, account_creation_date, DAY) = 3 THEN user_id
    END
      ) AS d3_retained
  FROM
    user_events
  GROUP BY
    user_id,
    country )
  -- Final calculation for retention percentages ensuring distinct user_id counts
SELECT
  COUNT(DISTINCT user_id) AS total_retained,
  COUNT(DISTINCT
    CASE
      WHEN d1_retained > 0 THEN user_id
  END
    ) / COUNT(DISTINCT user_id) * 100 AS d1_retention,
  COUNT(DISTINCT
    CASE
      WHEN d2_retained > 0 THEN user_id
  END
    ) / COUNT(DISTINCT user_id) * 100 AS d2_retention,
  COUNT(DISTINCT
    CASE
      WHEN d3_retained > 0 THEN user_id
  END
    ) / COUNT(DISTINCT user_id) * 100 AS d3_retention
FROM
  retention_metrics;