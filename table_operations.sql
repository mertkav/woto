  -- Brief Introduction: When I imported the CSV file into BigQuery, I noticed that the anonymized_user_id values were imported as floats. My goal was to convert this float column into a string, so I performed table operations, applied data pre-processing, and improved the readability of the data.
   -- Adding a new column `user_id` of type string.
ALTER TABLE
  dataset.data_table ADD COLUMN user_id STRING;
UPDATE
  dataset.data_table
SET
  user_id = SAFE_CAST(CAST(anonymized_user_id AS INT64) AS STRING)
WHERE
  anonymized_user_id IS NOT NULL;
  -- Dropping the `anonymized_user_id` column
ALTER TABLE
  dataset.data_table
DROP
  COLUMN anonymized_user_id;
  -- Selecting all the data to check them all
SELECT
  *
FROM
  `dataset.data_table`;
  --Creating a new table `dataset.data_table_arranged` with the desired column order
CREATE TABLE
  dataset.data_table_arranged AS
SELECT
  user_id,
  country,
  create_datetime,
  event_datetime,
  event_name,
  source_keyword
FROM
  dataset.data_table;
  -- Dropping the original table to replace it with the newly arranged version.
DROP TABLE
  dataset.data_table;
  --Renaming the newly created table back to the original table name.
ALTER TABLE
  dataset.data_table_arranged
RENAME
  TO data_table;
  -- Checking it 
SELECT
  *
FROM
  dataset.data_table
LIMIT
  10;
