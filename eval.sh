for stm in transactions.sql trips.sql buyers.sql
do
	echo "Executing: " $stm
	sqlite3 -header poc2.db < $stm
done

