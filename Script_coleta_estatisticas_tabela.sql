SELECT COLUMN_NAME, NUM_DISTINCT, NUM_NULLS, NUM_BUCKETS, DENSITY
  FROM DBA_TAB_COL_STATISTICS
 WHERE TABLE_NAME = 'TABLE_NAME'
 ORDER BY COLUMN_NAME;