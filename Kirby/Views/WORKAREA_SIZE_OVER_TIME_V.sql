CREATE OR REPLACE VIEW CAPSTONE_DEMO.WORKAREA_SIZE_OVER_TIME_V AS
/
SELECT
  A.MODULE,
  A.CLIENT_INFO,
  B.CPU_COUNT,
  B.DOP,
  B."_PGA_MAX_SIZE",
  B.DB_BIG_TABLE_CACHE_PERCENT || '%' AS BT_CACHE_TARGET,
  B.PARALLEL_DEGREE_POLICY,
  B.DB_CACHE_SIZE,
  B.IM_SIZE,
  B.INMEMORY_COMPRESSION,
  A.SNAPSHOT_ID,
  A.SNAPSHOT_TS,
  A.SQL_EXEC_START,
  ROUND(CAPSTONE_DEMO.INTERVAL_TO_SEC(A.SNAPSHOT_TS - A.SQL_EXEC_START),0) AS RUN_TIME_SEC,
  A.SQL_ID,
  A.SID,
  SUM(A.WORK_AREA_SIZE/POWER(1024,3)) AS WORK_AREA_SIZE_GB,
  SUM(A.EXPECTED_SIZE/POWER(1024,3)) AS EXPECTED_SIZE_GB,
  SUM(A.ACTUAL_MEM_USED/POWER(1024,3)) AS ACTUAL_MEM_USED_GB,
  SUM(A.MAX_MEM_USED/POWER(1024,3)) AS MAX_MEM_USED_GB,
  NVL(SUM(A.TEMPSEG_SIZE/POWER(1024,3)),0) AS TEMPSEG_SIZE_GB
FROM CAPSTONE_DEMO.SQL_WORKAREA_ACTIVE_HISTORY A
  INNER JOIN CAPSTONE_DEMO.EXPERIMENT_PARAMETERS_V B
    ON A.SQL_EXEC_START = B.SQL_EXEC_START
WHERE A.SQL_EXEC_START IS NOT NULL
GROUP BY
  A.MODULE,
  A.CLIENT_INFO,
  B.CPU_COUNT,
  B.DOP,
  B."_PGA_MAX_SIZE",
  B.DB_BIG_TABLE_CACHE_PERCENT,
  B.PARALLEL_DEGREE_POLICY,
  B.DB_CACHE_SIZE,
  B.IM_SIZE,
  B.INMEMORY_COMPRESSION,
  A.SNAPSHOT_ID,
  A.SNAPSHOT_TS,
  A.SQL_EXEC_START,
  A.SQL_ID
  A.SID,;

SELECT
  *
FROM CAPSTONE_DEMO.WORKAREA_SIZE_OVER_TIME_V;

SELECT
  A.MODULE,
  A.CLIENT_INFO,
  B.CPU_COUNT,
  B.DOP,
  B."_PGA_MAX_SIZE",
  B.DB_BIG_TABLE_CACHE_PERCENT || '%' AS BT_CACHE_TARGET,
  B.PARALLEL_DEGREE_POLICY,
  B.DB_CACHE_SIZE,
  B.IM_SIZE,
  B.INMEMORY_COMPRESSION,
  A.SQL_EXEC_START,
  A.SID,
  A.OPERATION_TYPE,
  A.OPERATION_ID,
  MAX(WORK_AREA_SIZE/POWER(1024,3)) AS MAX_WORK_AREA_SIZE_GB,
  MAX(A.EXPECTED_SIZE/POWER(1024,3)) AS MAX_EXPECTED_SIZE_GB,
  MAX(A.ACTUAL_MEM_USED/POWER(1024,3)) AS MAX_ACTUAL_MEM_USED_GB,
  MAX(A.MAX_MEM_USED/POWER(1024,3)) AS MAX_MAX_MEM_USED_GB,
  MAX(A.TEMPSEG_SIZE/POWER(1024,3)) AS MAX_TEMPSEG_SIZE_GB
FROM CAPSTONE_DEMO.SQL_WORKAREA_ACTIVE_HISTORY A
  INNER JOIN CAPSTONE_DEMO.EXPERIMENT_PARAMETERS_V B
    ON A.SQL_EXEC_START = B.SQL_EXEC_START
GROUP BY
  A.MODULE,
  A.CLIENT_INFO,
  B.CPU_COUNT,
  B.DOP,
  B."_PGA_MAX_SIZE",
  B.DB_BIG_TABLE_CACHE_PERCENT,
  B.PARALLEL_DEGREE_POLICY,
  B.DB_CACHE_SIZE,
  B.IM_SIZE,
  B.INMEMORY_COMPRESSION,
  A.SQL_EXEC_START,
  A.SID,
  A.OPERATION_TYPE,
  A.OPERATION_ID
ORDER BY
  MAX_ACTUAL_MEM_USED_GB DESC,
  A.SQL_EXEC_START;

    
SELECT
  MODULE,
  ACTION,
  CLIENT_INFO,
  SNAPSHOT_ID,
  SNAPSHOT_TS,
  SQL_EXEC_START,
  SQL_ID,
  SID,
  OPERATION_TYPE,
  OPERATION_ID,
  WORK_AREA_SIZE/POWER(1024,3) AS WORK_AREA_SIZE_GB,
  EXPECTED_SIZE/POWER(1024,3) AS EXPECTED_SIZE_GB,
  ACTUAL_MEM_USED/POWER(1024,3) AS ACTUAL_MEM_USED_GB,
  MAX_MEM_USED/POWER(1024,3) AS MAX_MEM_USED_GB,
  NUMBER_PASSES,
  TEMPSEG_SIZE/POWER(1024,3) AS TEMPSEG_SIZE_GB
FROM CAPSTONE_DEMO.SQL_WORKAREA_ACTIVE_HISTORY A
WHERE SQL_EXEC_START IN(TO_DATE('21-FEB-2017 16:50:29', 'dd-MON-yyyy hh24:mi:ss'))
--AND SID = 1138
ORDER BY
  SNAPSHOT_TS;

WITH DISTINCT_OPERATIONS AS

(
SELECT DISTINCT
  SQL_EXEC_START,
  SID,
  OPERATION_TYPE
FROM CAPSTONE_DEMO.SQL_WORKAREA_ACTIVE_HISTORY
WHERE ACTUAL_MEM_USED > 0
AND SQL_EXEC_START IN(TO_DATE('21-FEB-2017 16:50:29', 'dd-MON-yyyy hh24:mi:ss'))
--AND SID = 1707
)

SELECT
  SQL_EXEC_START,
  SID,
  COUNT(*)
FROM DISTINCT_OPERATIONS
GROUP BY
  SQL_EXEC_START,
  SID
HAVING COUNT(*) > 1
ORDER BY
  SQL_EXEC_START,
  SID;