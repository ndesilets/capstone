ALTER SESSION SET WORKAREA_SIZE_POLICY = AUTO;
ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 2147483647; --1 Byte short of 2GB
ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 1610612736; --1.5GB
ALTER SESSION SET HASH_AREA_SIZE = 536870912; --0.5GB


SELECT * FROM V$PX_SESSION ORDER BY SID;
SELECT * FROM V$ACTIVE_SESSION_HISTORY WHERE SESSION_ID = 317 ORDER BY SAMPLE_TIME DESC;
SELECT * FROM V$SQL_MONITOR WHERE ACTION = 'RESOURCE_MONITORING';
SELECT * FROM V$SYSSTAT WHERE NAME LIKE '%pga%';
SELECT * FROM V$SESSTAT A INNER JOIN V$STATNAME B ON A.STATISTIC# = B.STATISTIC#  ORDER BY A.STATISTIC#, A.SID;
SELECT * FROM V$PQ_SYSSTAT;
SELECT * FROM V$PQ_SESSTAT;
SELECT * FROM V$SESSMETRIC;
SELECT * FROM V$STATNAME WHERE UPPER(DISPLAY_NAME) LIKE '%TIME%' ORDER BY STATISTIC#;
SELECT * FROM V$SESS_TIME_MODEL;
SELECT DISTINCT STAT_NAME FROM V$SESS_TIME_MODEL ORDER BY STAT_NAME;
SELECT * FROM V$SYS_TIME_MODEL;
SELECT * FROM V$SQL;
SELECT * FROM V$SQL_WORKAREA;
SELECT * FROM V$SQL_WORKAREA_ACTIVE;
SELECT * FROM V$SORT_SEGMENT;
SELECT * FROM V$SORT_USAGE;
SELECT * FROM V$TEMPSEG_USAGE;
SELECT * FROM DBA_TEMP_FREE_SPACE;
SELECT * FROM V$SESSION WHERE ACTION = 'RESOURCE_MONITORING';
SELECT * FROM V$PROCESS;
SELECT * FROM V$THREAD;
SELECT * FROM V$EVENT_NAME;
SELECT * FROM V$SQL WHERE SQL_TEXT LIKE '%FIND_ME%' AND SQL_TEXT NOT LIKE 'V$SQL' AND SQL_ID = '';
SELECT DBMS_SQLTUNE.REPORT_SQL_MONITOR(SQL_ID => '3rccrbdxzzbc8', TYPE => 'ACTIVE', REPORT_LEVEL =>'ALL') FROM DUAL;
SELECT * FROM DBA_HIST_SQLSTAT;
SELECT * FROM DBA_TABLESPACES;
SELECT * FROM V$PGASTAT;
SELECT * FROM V$SYSTEM_EVENT;
SELECT * FROM V$SESS_IO;
SELECT * FROM V_$SQLSTATS;
SELECT * FROM V$BT_SCAN_OBJ_TEMPS;
SELECT * FROM V$BT_SCAN_CACHE;
SELECT * FROM V$SGA;
SELECT * FROM V$SGAINFO;
SELECT * FROM V$SGASTAT;
SELECT * FROM V$SGA_CURRENT_RESIZE_OPS;
SELECT * FROM V$SGA_DYNAMIC_COMPONENTS;
SELECT * FROM V$SGA_DYNAMIC_FREE_MEMORY;
SELECT * FROM V$SGA_RESIZE_OPS ORDER BY COMPONENT;
SELECT * FROM V$SGA_TARGET_ADVICE;
SELECT * FROM V$PARAMETER WHERE NAME LIKE '%parallel%';

SHOW PARAMETER PARALLEL;

SELECT 
  NAME,
  VALUE,
  DISPLAY_VALUE,
  ISDEFAULT,
  ISSES_MODIFIABLE,
  ISSYS_MODIFIABLE,
  ISPDB_MODIFIABLE,
  ISINSTANCE_MODIFIABLE,
  ISMODIFIED,
  ISADJUSTED,
  DESCRIPTION,
  UPPER(NAME),
  '(SELECT VALUE FROM V$PARAMETER WHERE NAME = ''' || NAME || ''') AS ' || UPPER(NAME) || ',' AS SELECT_STATEMENT
FROM V$PARAMETER
WHERE NAME IN ('pga_aggregate_limit', 'pga_aggregate_target', '_pga_max_size', 'sga_max_size', 'sga_target', 'db_cache_size', 'db_big_table_cache_percent_target', 'parallel_degree_policy', 'parallel_min_time_threshold')
--WHERE LOWER(NAME) LIKE '%max_size%'
ORDER BY
  NAME;

SELECT
  'SELECT * FROM ' || VIEW_NAME || ';'
FROM DBA_VIEWS
WHERE VIEW_NAME LIKE 'V_$%SGA%'
ORDER BY
  VIEW_NAME;
  
SELECT
  NAME,
  BYTES/POWER(1024,3) AS GB,
  RESIZEABLE
FROM V$SGAINFO
ORDER BY
  GB DESC;

SELECT
  POOL,
  NAME,
  BYTES/POWER(1024,3) AS GB
FROM V$SGASTAT
ORDER BY
  GB DESC;


WITH TABLE_LIST AS

(
SELECT 
  TABLE_NAME 
FROM DBA_TAB_COLS 
WHERE TABLE_NAME LIKE 'V_$%' 
AND COLUMN_NAME LIKE '%WRITE%'
)

SELECT
  *
FROM DBA_TAB_COLS A
  INNER JOIN TABLE_LIST B
    ON A.TABLE_NAME = B.TABLE_NAME
WHERE A.COLUMN_NAME = 'SID';




GRANT SELECT ON V_$SQL_MONITOR TO CAPSTONE_DEMO;
GRANT SELECT ON V_$SESSION TO CAPSTONE_DEMO;
GRANT SELECT ON V_$SESS_TIME_MODEL TO CAPSTONE_DEMO;
GRANT SELECT ON V_$PX_SESSION TO CAPSTONE_DEMO;
GRANT SELECT ON V_$SQL_MONITOR TO CAPSTONE_DEMO;
GRANT SELECT ON V_$PROCESS TO CAPSTONE_DEMO;
GRANT SELECT ON V$TEMPSEG_USAGE TO CAPSTONE_DEMO;
GRANT SELECT ON DBA_TABLESPACES TO CAPSTONE_DEMO;
GRANT SELECT ON V_$SQL_WORKAREA_ACTIVE TO CAPSTONE_DEMO;

/*+ Query for finding system level PGA settings and usage */
SELECT 
  NAME,
  CASE
    WHEN UNIT = 'bytes' THEN VALUE/POWER(1024,3)
    ELSE VALUE
  END AS VALUE,
  CASE
    WHEN UNIT = 'bytes' THEN 'GB'
    ELSE 'Count'
  END AS UNIT
FROM V$PGASTAT

UNION ALL

SELECT
  A.KSPPINM AS NAME,
  CASE
    WHEN A.KSPPINM = '_pga_max_size' THEN B.KSPPSTVL/POWER(1024,3)
    WHEN A.KSPPINM = '_smm_max_size' THEN B.KSPPSTVL/POWER(1024,2)
    WHEN A.KSPPINM = '_smm_px_max_size' THEN B.KSPPSTVL/POWER(1024,2)
    WHEN A.KSPPINM = '_smm_isort_cap' THEN B.KSPPSTVL/POWER(1024,1)
    ELSE B.KSPPSTVL/POWER(1024,3)
  END AS VALUE,
  CASE
    WHEN A.KSPPINM = '_smm_isort_cap' THEN 'MB'
    ELSE 'GB' 
  END AS UNITS
FROM X$KSPPI A
  INNER JOIN X$KSPPCV B
    ON A.INDX = B.INDX
  INNER JOIN X$KSPPSV C
    ON A.INDX = C.INDX
WHERE A.KSPPINM IN ('_pga_max_size','_smm_max_size','_smm_px_max_size', '_smm_isort_cap');

SELECT * FROM X$KSPPI A
  INNER JOIN X$KSPPCV B
    ON A.INDX = B.INDX
WHERE A.KSPPINM IN ('_pga_max_size','_smm_max_size','_smm_px_max_size', '_smm_isort_cap');

SELECT * FROM X$KSPPI A
  INNER JOIN X$KSPPCV B
    ON A.INDX = B.INDX
  INNER JOIN X$KSPPSV C
    ON A.INDX = C.INDX;
  
/* 
Query for finding PGA usage of a single SLQ_ID.
*/
SELECT 
  B.SQL_ID,
  B.PROGRAM,
  A.PNAME,
  B.SID,
  A.PID,
  A.SPID,
  A.PGA_USED_MEM/POWER(1024,2) AS PGA_USED_MEM_MB,
  A.PGA_ALLOC_MEM/POWER(1024,2) AS PGA_ALLOC_MEM_MB,
  A.PGA_MAX_MEM/POWER(1024,2) AS PGA_MAX_MEM_MB,
  A.PGA_FREEABLE_MEM/POWER(1024,2) AS PGA_FREEABLE_MEM_MB,
  SUM(A.PGA_USED_MEM/POWER(1024,2)) OVER(PARTITION BY B.SQL_ID) AS TOTAL_PGA_USED_MEM_MB,
  SUM(A.PGA_ALLOC_MEM/POWER(1024,2)) OVER(PARTITION BY B.SQL_ID) AS TOTAL_PGA_ALLOC_MEM_MB,
  SUM(A.PGA_MAX_MEM/POWER(1024,2)) OVER(PARTITION BY B.SQL_ID) AS TOTAL_PGA_MAX_MEM_MB,
  SUM(A.PGA_FREEABLE_MEM/POWER(1024,2)) OVER(PARTITION BY B.SQL_ID) AS TOTAL_PGA_FREEABLE_MEM_MB
FROM V$PROCESS A
  INNER JOIN V$SESSION B
    ON A.ADDR = B.PADDR
  
/*+ Query to see TEMP space usage on the whole */
SELECT 
  A.TABLESPACE_NAME,
  A.TABLESPACE_SIZE/POWER(1024,3) AS TABLESPACE_SIZE_GB,
  A.ALLOCATED_SPACE/POWER(1024,3) AS ALLOCATED_SPACE_GB,
  A.FREE_SPACE/POWER(1024,3) AS FREE_SPACE_GB,
  (A.TABLESPACE_SIZE - A.FREE_SPACE)/POWER(1024,3) AS USED_SPACE_GB
FROM DBA_TEMP_FREE_SPACE A;
  
/* SQL Workarea stats regrading the optimal size of things and the degree of things */
SELECT 
  A.SQL_ID,
  A.CHILD_NUMBER,
  A.OPERATION_TYPE,
  A.POLICY,
  A.ESTIMATED_OPTIMAL_SIZE/POWER(1024,3) AS ESTIMATED_OPT_SIZE_GB,
  A.ESTIMATED_ONEPASS_SIZE/POWER(1024,3) AS ESTIMATED_ONE_PASS_SIZE_GB,
  A.LAST_MEMORY_USED/POWER(1024,3) AS LAST_MEMORY_USED,
  A.LAST_DEGREE
FROM V$SQL_WORKAREA A;
WHERE SQL_ID = '99zbmkxg2266u';

/* 
Query the workarea histogram and distribution of PGA sizing.
Need to figure out how this is estimated
*/
SELECT
  LOW_OPTIMAL_SIZE/1024/1024/1024 AS LOW_OPT_SIZE_GB,
  (HIGH_OPTIMAL_SIZE + 1)/1024/1024/1024 AS HIGH_OPT_SIZE_GB,
  OPTIMAL_EXECUTIONS,
  ONEPASS_EXECUTIONS,
  MULTIPASSES_EXECUTIONS,
  TOTAL_EXECUTIONS
FROM V$SQL_WORKAREA_HISTOGRAM;

SELECT 
  A.MACHINE,
  A.SESSION_ID,
  A.SAMPLE_ID,
  A.SQL_EXEC_START,
  A.SAMPLE_TIME,
  CAPSTONE_DEMO.INTERVAL_TO_SEC(A.SAMPLE_TIME - SQL_EXEC_START) AS ELAPSED_TIME_SEC,
  A.SQL_ID,
  A.TOP_LEVEL_SQL_ID,
  A.SQL_OPNAME,
  A.EVENT,
  A.WAIT_CLASS,
  A.WAIT_TIME,
  A.SESSION_STATE,
  A.TIME_WAITED,
  A.BLOCKING_SESSION_STATUS,
  A.TM_DELTA_TIME/1E6 AS TM_DELTA_TIME_SEC,
  A.TM_DELTA_CPU_TIME/1E6 AS TM_DELTA_CPU_TIME_SEC,
  A.TM_DELTA_DB_TIME/1E6 AS TM_DELTA_DB_TIME_SEC,
  A.DELTA_TIME,
  A.DELTA_READ_IO_REQUESTS,
  A.DELTA_WRITE_IO_REQUESTS,
  A.DELTA_READ_IO_BYTES,
  A.DELTA_WRITE_IO_BYTES,
  A.DELTA_INTERCONNECT_IO_BYTES,
  A.PGA_ALLOCATED/POWER(1024,3) AS PGA_ALLOCATED_GB,
  A.TEMP_SPACE_ALLOCATED/POWER(1024,3) AS TEMP_SPACE_ALLOCATED_GB
FROM V$ACTIVE_SESSION_HISTORY A
WHERE SQL_ID = 
(
SELECT DISTINCT 
  LAST_VALUE(SQL_ID) OVER(ORDER BY LAST_REFRESH_TIME ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS SQL_ID
FROM V$SQL_MONITOR 
WHERE SQL_TEXT LIKE '%FIND_ME%'
)
ORDER BY
  SAMPLE_ID DESC;
  
SELECT
  *
FROM V$ACTIVE_SESSION_HISTORY
ORDER BY
  SAMPLE_ID DESC;
  
SELECT
  *
FROM DBA_HIST_ACTIVE_SESS_HISTORY 
ORDER BY 
  SAMPLE_TIME DESC;


  
WITH TESTING AS

(
SELECT 
  * 
FROM V$SESS_TIME_MODEL B
  INNER JOIN V$PX_SESSION C
    ON B.SID = C.SID
WHERE 1=1
--AND UPPER(A.DISPLAY_NAME) LIKE '%TIME%'
--AND C.QCSID = 94
)

SELECT
  STAT_NAME,
  MAX(VALUE)/1E6 AS MAX_VALUE,
  SUM(VALUE)/1E6 AS SUM_VALUE
FROM TESTING
GROUP BY
  STAT_NAME
ORDER BY
  MAX_VALUE DESC;
  
SELECT
  *
FROM V$TEMPSEG_USAGE A
  LEFT JOIN V$SESSION B
    ON A.SESSION_ADDR = B.SADDR;

SELECT * FROM V$PROCESS;

show parameter _area_size;

SELECT
  A.PID,
  A.SPID,
  B.SID
FROM V$PROCESS A
  INNER JOIN V$SESSION B
    ON A.ADDR = B.PADDR;
    
SELECT * FROM DUAL;