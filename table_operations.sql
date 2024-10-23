  -- Brief Introduction: When I imported the CSV file into BigQuery, I noticed that the anonymized_user_id values were imported as floats. My goal was to convert this float column into a string, so I performed table operations, applied data pre-processing, and improved the readability of the data.
   -- 1. Adding a new column `user_id` of type string.
ALTER TABLE
  dataset.data_table ADD COLUMN user_id STRING;
  -- 2. Populating the newly added `user_id` column by casting `anonymized_user_id` to a string and removing the decimal point.
UPDATE
  dataset.data_table
SET
  user_id = SAFE_CAST(CAST(anonymized_user_id AS INT64) AS STRING)
WHERE
  anonymized_user_id IS NOT NULL;
  -- 3. Dropping the `anonymized_user_id` column, as it is no longer needed since we've transferred its data to `user_id`.
ALTER TABLE
  dataset.data_table
DROP
  COLUMN anonymized_user_id;
  -- 4. Selecting all the data from `dataset.data_table` to review the current structure of the table.
SELECT
  *
FROM
  `dataset.data_table`;
  -- 5. Creating a new table `dataset.data_table_arranged` with the desired column order. Here, we are moving `user_id` to the first column and ordering other columns.
CREATE TABLE
  dataset.data_table_arranged AS
SELECT
  user_id,
  country,
  create_datetime,
  event_datetime,
  source_keyword
FROM
  dataset.data_table;
  -- 6. Dropping the original table to replace it with the newly arranged version.
DROP TABLE
  dataset.data_table;
  -- 7. Renaming the newly created table (`data_table_arranged`) back to the original table name.
ALTER TABLE
  dataset.data_table_arranged
RENAME
  TO data_table;
  -- 8. Verifying the structure.
SELECT
  *
FROM
  dataset.data_table
LIMIT
  10;
