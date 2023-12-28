-- I can try to translate Sql code for sqlite to mysql for you. Here is one possible solution:

-- Drop the table if it exists
DROP TABLE IF EXISTS purchases;
-- Create the table with the same columns and types
CREATE TABLE purchases (
rec_id INT,
panel_id INT,
household_id INT,
pur_date DATE,
shop_id INT,
packs INT,
volume FLOAT,
value FLOAT,
article_id INT,
category_id INT,
brand_id INT,
brand_factor REAL,
rw REAL
);
-- Load the data from a text file into the table
LOAD DATA INFILE 'pur.txt' INTO TABLE purchases
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';
-- Turn on the headers for the output
SET SQL_MODE = 'ANSI';
-- Select the first 10 rows from the table
SELECT * FROM purchases LIMIT 10;

-- This code works by using the MySQL syntax for dropping, creating, and loading tables https://bing.com/search?q=translate+Sql+code+for+sqlite+to+mysql&form=SKPBOT https://stackoverflow.com/questions/18671/quick-easy-way-to-migrate-sqlite3-to-mysql. It also uses the ANSI mode to display the headers in the output https://www.rebasedata.com/convert-sqlite-to-mysql-online.
