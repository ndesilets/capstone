CREATE OR REPLACE PACKAGE CAPSTONE_DEMO.RESOURCE_MONITOR AS 

PROCEDURE RESOURCE_USAGE_MONITORING(VIEW_NAME VARCHAR2);
PROCEDURE RESOURCE_USAGE_MONITORING_V2(LOOP_COUNT NUMBER, TIME_BETWEEN_LOOPS NUMBER);
PROCEDURE PARAMETERS_HISTORY_INSERT;
  
END RESOURCE_MONITOR;
/

CREATE OR REPLACE PACKAGE BODY CAPSTONE_DEMO.RESOURCE_MONITOR AS 

PROCEDURE RESOURCE_USAGE_MONITORING(VIEW_NAME VARCHAR2) AS

BEGIN

INSERT INTO CAPSTONE_DEMO.RESOURCE_USAGE_MONITORING

WITH FINDING_SQL_START AS --DONT_FIND_ME

(
SELECT DISTINCT
  LAST_VALUE(SQL_ID) OVER(ORDER BY SQL_EXEC_START ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS SQL_ID,
  LAST_VALUE(SQL_EXEC_START) OVER(ORDER BY SQL_EXEC_START ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS SQL_EXEC_START,
  LAST_VALUE(SID) OVER(ORDER BY SQL_EXEC_START ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS SID
FROM V$SQL_MONITOR
WHERE SQL_TEXT LIKE '%FIND_ME%'
AND SQL_TEXT NOT LIKE '%DONT_FIND_ME%'
),

FINDING_SIDS AS

(
SELECT
  SQL_ID,
  SQL_EXEC_START,
  SID,
  SADDR
FROM V$SESSION
WHERE SQL_EXEC_START = (SELECT SQL_EXEC_START FROM FINDING_SQL_START)
),

WORKAREA_MOD AS

(
SELECT 
  A.SQL_ID,
  A.SQL_EXEC_START,
  A.SID,
  A.OPERATION_TYPE,
  A.OPERATION_ID,
  A.WORK_AREA_SIZE,
  A.EXPECTED_SIZE,
  A.ACTUAL_MEM_USED,
  A.MAX_MEM_USED,
  A.NUMBER_PASSES,
  A.TEMPSEG_SIZE
FROM V$SQL_WORKAREA_ACTIVE A
  INNER JOIN FINDING_SQL_START B
    ON A.SQL_EXEC_START = B.SQL_EXEC_START
),

WORKAREA_PIVOT AS

(
SELECT
  *
FROM WORKAREA_MOD
PIVOT (
  SUM(WORK_AREA_SIZE) AS WORK_AREA_SIZE,
  SUM(EXPECTED_SIZE) AS EXPECTED_SIZE,
  SUM(ACTUAL_MEM_USED) AS ACTUAL_MEM_USED,
  SUM(MAX_MEM_USED) AS MAX_MEM_USED,
  SUM(NUMBER_PASSES) AS NUMBER_PASSES,
  SUM(TEMPSEG_SIZE) AS TEMPSEG_SIZE
  FOR OPERATION_TYPE IN 
                        ('GROUP BY (HASH)' AS GROUP_BY_HASH, 
                        'SORT (v2)' AS SORT_V2, 
                        'HASH-JOIN' AS HASH_JOIN,
                        'WINDOW (SORT)' AS WINDOW_SORT
                        )
      )
),

FINDING_SESSION_TIME_STATS AS

(
SELECT 
  C.SQL_ID,
  C.SQL_EXEC_START,
  C.SADDR,
  B.QCSID,
  B.SID,
  A.STAT_NAME,
  A.VALUE
FROM V$SESS_TIME_MODEL A
  INNER JOIN V$PX_SESSION B
    ON A.SID = B.SID
  INNER JOIN FINDING_SIDS C
    ON B.SID = C.SID
),

PIVOT_SESSION_TIME_STATS AS

(
SELECT
  *
FROM FINDING_SESSION_TIME_STATS
PIVOT (
  SUM(VALUE)
  FOR STAT_NAME IN ('DB time' AS DB_TIME, 'sql execute elapsed time' AS ELAPSED_TIME, 'DB CPU' AS CPU_TIME)
  )
),

IO_DATA AS

(
SELECT
  SQL_ID,
  SQL_EXEC_START,
  SID,
  BUFFER_GETS,
  DISK_READS,
  DIRECT_WRITES,
  IO_INTERCONNECT_BYTES,
  PHYSICAL_READ_REQUESTS,
  PHYSICAL_READ_BYTES,
  PHYSICAL_WRITE_REQUESTS,
  PHYSICAL_WRITE_BYTES,
  USER_IO_WAIT_TIME,
  SQL_TEXT
FROM V$SQL_MONITOR
)

SELECT
  NULL AS EXPERIMENT_NUMBER,
  NULL AS RUN_NUMBER,
  (SELECT VALUE FROM V$PARAMETER WHERE NAME = '_pga_max_size') AS PGA_MAX_SIZE,
  (SELECT VALUE FROM V$PARAMETER WHERE NAME = 'db_big_table_cache_percent_target') AS DB_BIG_TABLE_CACHE_PERCENT,
  (SELECT VALUE FROM V$PARAMETER WHERE NAME = 'db_cache_size') AS DB_CACHE_SIZE,
  (SELECT VALUE FROM V$PARAMETER WHERE NAME = 'parallel_degree_policy') AS PARALLEL_DEGREE_POLICY,
  (SELECT VALUE FROM V$PARAMETER WHERE NAME = 'parallel_min_time_threshold') AS PARALLEL_MIN_TIME_THRESHOLD,
  (SELECT VALUE FROM V$PARAMETER WHERE NAME = 'pga_aggregate_limit') AS PGA_AGGREGATE_LIMIT,
  (SELECT VALUE FROM V$PARAMETER WHERE NAME = 'pga_aggregate_target') AS PGA_AGGREGATE_TARGET,
  (SELECT VALUE FROM V$PARAMETER WHERE NAME = 'sga_max_size') AS SGA_MAX_SIZE,
  (SELECT VALUE FROM V$PARAMETER WHERE NAME = 'sga_target') AS SGA_TARGET,
  SYSTIMESTAMP AS SNAPSHOT_TS,
  A.SQL_ID,
  A.SQL_EXEC_START,
  A.QCSID,
  A.SID,
  A.DB_TIME,
  A.ELAPSED_TIME,
  A.CPU_TIME,
  C.BUFFER_GETS,
  C.DISK_READS,
  C.DIRECT_WRITES,
  C.IO_INTERCONNECT_BYTES,
  C.PHYSICAL_READ_REQUESTS,
  C.PHYSICAL_READ_BYTES,
  C.PHYSICAL_WRITE_REQUESTS,
  C.PHYSICAL_WRITE_BYTES,
  C.USER_IO_WAIT_TIME,
  B.OPERATION_ID,
  B.GROUP_BY_HASH_WORK_AREA_SIZE,
  B.GROUP_BY_HASH_EXPECTED_SIZE,
  GROUP_BY_HASH_ACTUAL_MEM_USED,
  GROUP_BY_HASH_MAX_MEM_USED,
  GROUP_BY_HASH_NUMBER_PASSES,
  GROUP_BY_HASH_TEMPSEG_SIZE,
  SORT_V2_WORK_AREA_SIZE,
  SORT_V2_EXPECTED_SIZE,
  SORT_V2_ACTUAL_MEM_USED,
  SORT_V2_MAX_MEM_USED,
  SORT_V2_NUMBER_PASSES,
  SORT_V2_TEMPSEG_SIZE,
  HASH_JOIN_WORK_AREA_SIZE,
  HASH_JOIN_EXPECTED_SIZE,
  HASH_JOIN_ACTUAL_MEM_USED,
  HASH_JOIN_MAX_MEM_USED,
  HASH_JOIN_NUMBER_PASSES,
  HASH_JOIN_TEMPSEG_SIZE,
  WINDOW_SORT_WORK_AREA_SIZE,
  WINDOW_SORT_EXPECTED_SIZE,
  WINDOW_SORT_ACTUAL_MEM_USED,
  WINDOW_SORT_MAX_MEM_USED,
  WINDOW_SORT_NUMBER_PASSES,
  WINDOW_SORT_TEMPSEG_SIZE,
  C.SQL_TEXT
FROM PIVOT_SESSION_TIME_STATS A
  LEFT OUTER JOIN WORKAREA_PIVOT B
    ON A.SQL_EXEC_START = B.SQL_EXEC_START
    AND A.SID = B.SID
    AND A.SQL_ID = B.SQL_ID
  LEFT OUTER JOIN IO_DATA C
    ON A.SQL_EXEC_START = C.SQL_EXEC_START
    AND A.SID = C.SID
    AND A.SQL_ID = C.SQL_ID;

COMMIT;

END RESOURCE_USAGE_MONITORING;

PROCEDURE RESOURCE_USAGE_MONITORING_V2(LOOP_COUNT NUMBER, TIME_BETWEEN_LOOPS NUMBER) AS

BEGIN

FOR A IN 1..LOOP_COUNT LOOP

INSERT INTO CAPSTONE_DEMO.SQL_MONITOR_HISTORY

SELECT
  MODULE,
  ACTION,
  CLIENT_INFO,
  A AS SNAPSHOT_ID,
  SYSTIMESTAMP AS SNAPSHOT_TS,
  SQL_EXEC_START,
  SQL_ID,
  SID,
  PX_MAXDOP,
  PX_SERVERS_REQUESTED,
  PX_SERVERS_ALLOCATED,
  BUFFER_GETS,
  DISK_READS,
  DIRECT_WRITES,
  IO_INTERCONNECT_BYTES,
  PHYSICAL_READ_REQUESTS,
  PHYSICAL_READ_BYTES,
  PHYSICAL_WRITE_REQUESTS,
  PHYSICAL_WRITE_BYTES,
  USER_IO_WAIT_TIME,
  SQL_TEXT
FROM V$SQL_MONITOR A
WHERE A.ACTION = 'RESOURCE_MONITORING';

INSERT INTO CAPSTONE_DEMO.SQL_WORKAREA_ACTIVE_HISTORY

SELECT
  B.MODULE,
  B.ACTION,
  B.CLIENT_INFO,
  A AS SNAPSHOT_ID,
  SYSTIMESTAMP AS SNAPSHOT_TS,
  B.SQL_EXEC_START,
  B.SQL_ID,
  B.SID,
  A.OPERATION_TYPE,
  A.OPERATION_ID,
  A.WORK_AREA_SIZE,
  A.EXPECTED_SIZE,
  A.ACTUAL_MEM_USED,
  A.MAX_MEM_USED,
  A.NUMBER_PASSES,
  A.TEMPSEG_SIZE
FROM V$SQL_WORKAREA_ACTIVE A
  INNER JOIN V$SESSION B
    ON A.SID = B.SID
WHERE B.ACTION = 'RESOURCE_MONITORING';

INSERT INTO CAPSTONE_DEMO.SESSION_PROCESS_HISTORY

SELECT
  A.MODULE,
  A.ACTION,
  A.CLIENT_INFO,
  A AS SNAPSHOT_ID,
  SYSTIMESTAMP AS SNAPSHOT_TS,
  A.SQL_EXEC_START,
  A.SQL_ID,
  A.SID,
  A.SADDR,
  B.PGA_USED_MEM,
  B.PGA_ALLOC_MEM,
  B.PGA_FREEABLE_MEM,
  B.PGA_MAX_MEM
FROM V$SESSION A
  INNER JOIN V$PROCESS B
    ON A.PADDR = B.ADDR
WHERE A.ACTION = 'RESOURCE_MONITORING';

INSERT INTO CAPSTONE_DEMO.SESS_TIME_MODEL_PX_SESS_HIST

SELECT
  C.MODULE,
  C.ACTION,
  C.CLIENT_INFO,
  A AS SNAPSHOT_ID,
  SYSTIMESTAMP AS SNAPSHOT_TS,
  C.SQL_EXEC_START,
  C.SQL_ID,
  C.SID,
  A.STAT_NAME,
  A.VALUE,
  B.QCSID
FROM V$SESS_TIME_MODEL A
  INNER JOIN V$PX_SESSION B
    ON A.SID = B.SID
  INNER JOIN V$SESSION C
    ON A.SID = C.SID
WHERE C.ACTION = 'RESOURCE_MONITORING'
AND VALUE > 0;

COMMIT;

DBMS_LOCK.SLEEP(SECONDS => TIME_BETWEEN_LOOPS);

END LOOP;

END RESOURCE_USAGE_MONITORING_V2;

PROCEDURE PARAMETERS_HISTORY_INSERT AS

BEGIN

INSERT INTO CAPSTONE_DEMO.PARAMETERS_HISTORY

SELECT 
  SYSTIMESTAMP AS SNAPSHOT_TS,
  A.NAME,
  A.VALUE,
  A.DISPLAY_VALUE,
  A.ISDEFAULT,
  A.ISSES_MODIFIABLE,
  A.ISSYS_MODIFIABLE,
  A.ISPDB_MODIFIABLE,
  A.ISINSTANCE_MODIFIABLE,
  A.ISMODIFIED,
  A.ISADJUSTED,
  A.DESCRIPTION
FROM V$PARAMETER A
WHERE NAME IN (
                'pga_aggregate_limit', 
                'pga_aggregate_target', 
                '_pga_max_size', 
                'sga_max_size', 
                'sga_target', 
                'db_cache_size', 
                'db_big_table_cache_percent_target', 
                'parallel_degree_policy', 
                'parallel_min_time_threshold',
                'inmemory_size',
                'parallel_servers_target',
                'parallel_degree_limit',
                'parallel_degree_level',
                'parallel_threads_per_cpu',
                'parallel_execution_message_size',
                'parallel_min_servers',
                'parallel_max_servers',
                'parallel_adaptive_multi_user'
               );
               
COMMIT;

END PARAMETERS_HISTORY_INSERT;

END RESOURCE_MONITOR;
/