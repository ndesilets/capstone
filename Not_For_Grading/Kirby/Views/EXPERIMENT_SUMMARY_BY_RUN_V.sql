EXECUTE DBMS_MVIEW.REFRESH('CAPSTONE_DEMO.EXPERIMENT_SUMMARY_BY_RUN_MV', 'C');
CREATE MATERIALIZED VIEW CAPSTONE_DEMO.EXPERIMENT_SUMMARY_BY_RUN_MV AS

SELECT
  A.MODULE,
  A.CLIENT_INFO,
  A.SQL_EXEC_START,
  A.RUN_NUMBER,
  A.DOP,
  A."_PGA_MAX_SIZE",
  A.BT_CACHE_TARGET,
  A.PARALLEL_DEGREE_POLICY,
  A.DB_CACHE_SIZE,
  A.IM_SIZE,
  A.INMEMORY_COMPRESSION,
  A.RUN_TIME_SEC,
  A.DB_TIME_SEC,
  A.CPU_TIME_SEC,
  C.USER_IO_WAIT_TIME_SEC,
  (A.CPU_TIME_SEC/A.RUN_TIME_SEC)/A.CPU_COUNT AS CEI,
  B.WORK_AREA_SIZE_GB,
  B.EXPECTED_SIZE_GB,
  B.ACTUAL_MEM_USED_GB,
  B.MAX_MEM_USED_GB,
  B.TEMPSEG_SIZE_GB,
  C.BUFFER_GETS_GB,
  C.IO_INTERCONNECT_GB,
  C.PHYSICAL_READ_GB,
  C.PHYSICAL_WRITE_GB
FROM CAPSTONE_DEMO.TIME_USAGE_SUMMARY_V A
  INNER JOIN CAPSTONE_DEMO.WORK_AREA_SUMMARY_V B
    ON A.SQL_EXEC_START = B.SQL_EXEC_START
  INNER JOIN CAPSTONE_DEMO.IO_SUMMARY_V C
    ON A.SQL_EXEC_START = C.SQL_EXEC_START;

CREATE OR REPLACE VIEW CAPSTONE_DEMO.EXPERIMENT_SUMMARY_BY_RUN_V AS

SELECT
  *
FROM CAPSTONE_DEMO.EXPERIMENT_SUMMARY_BY_RUN_MV;

SELECT DISTINCT
  MODULE
FROM CAPSTONE_DEMO.EXPERIMENT_SUMMARY_BY_RUN_V
WHERE MODULE = 'IMCS_EXPERIMENT'
AND CLIENT_INFO = 'LEAD_LAG_V1'
--AND IM_COMPRESS_LEVEL = 'FOR CAPACITY HIGH'
--AND DOP = 'DOP = 32'
ORDER BY
--  CLIENT_INFO,
--  IM_COMPRESS_LEVEL,
  SQL_EXEC_START DESC;
  
SELECT
  COUNT(*)
FROM CAPSTONE_DEMO.LEAD_LAG_TEST_V1;