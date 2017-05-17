CREATE OR REPLACE VIEW CAPSTONE_DEMO.PROCESS_PGA_OVER_TIME_V

AS

SELECT
  A.SNAPSHOT_ID,
  A.SNAPSHOT_TS,
  A.SID,
  A.SQL_ID,
  A.SQL_EXEC_START_TIME,
  A.PGA_USED_MEM/POWER(1024,3) AS PGA_USED_MEM_GB,
  A.PGA_ALLOC_MEM/POWER(1024,3) AS PGA_ALLOC_MEM_GB,
  A.PGA_FREEABLE_MEM/POWER(1024,3) AS PGA_FREEABLE_MEM_GB,
  A.PGA_MAX_MEM/POWER(1024,3) AS PGA_MAX_MEM_GB
FROM CAPSTONE_DEMO.SESSION_PROCESS_HISTORY A;

SELECT
  *
FROM CAPSTONE_DEMO.PROCESS_PGA_OVER_TIME_V;