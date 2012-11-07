FROM stocks stk
    SELECT stk.tradeDate, stk.open, stk.high, stk.low,stk.close,stk.volume
    WHERE stk.close > 160.00;
