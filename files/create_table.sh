DROP TABLE stocks;

CREATE EXTERNAL TABLE stocks( tradeDate STRING, open FLOAT,
                     high FLOAT, low FLOAT, close FLOAT,
                     volume BIGINT, adjClose FLOAT, stockSymbol STRING )
     ROW FORMAT DELIMITED FIELDS TERMINATED BY '44' LINES TERMINATED BY '\n'
     STORED AS TEXTFILE
     LOCATION '/app/hadoop/tmp/inputs/stk/';
 
FROM stocks stk
    SELECT stk.tradeDate, stk.open, stk.high, stk.low,stk.close,stk.volume
    WHERE stk.close > 18.00;
  
