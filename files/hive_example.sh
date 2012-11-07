# hive table creation, loading data and query

hadoop dfs -rmr /app/hadoop/tmp/inputs/stk/
hive -f create_table.sh
hadoop dfs -copyFromLocal ge.txt /app/hadoop/tmp/inputs/stk/
hive -f query.sh  
