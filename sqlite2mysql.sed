s/date text/date date/
/.mode tabs/d
s/.import \([^ ]*\).txt \([^ ]*\)/load data local infile '\1.txt' into table \2\;/
/.headers on/d
