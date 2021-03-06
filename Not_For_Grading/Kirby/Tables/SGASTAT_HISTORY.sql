TRUNCATE TABLE CAPSTONE_DEMO.SGASTAT_HISTORY;
DROP TABLE CAPSTONE_DEMO.SGASTAT_HISTORY;
CREATE TABLE CAPSTONE_DEMO.SGASTAT_HISTORY
(
SNAPSHOT_TS TIMESTAMP,
SNAPSHOT_ID NUMBER,
POOL VARCHAR2(12),
NAME VARCHAR2(26),
BYTES NUMBER,
CON_ID NUMBER
);

INSERT INTO CAPSTONE_DEMO.SGASTAT_HISTORY

SELECT
  SYSTIMESTAMP AS SNAPSHOT_TS,
  NULL AS SNAPSHOT_ID,
  A.POOL,
  A.NAME,
  A.BYTES,
  A.CON_ID
FROM V$SGASTAT A;

COMMIT;

WITH EXPERIMENT_FILTER AS

(
SELECT
  *
FROM CAPSTONE_DEMO.TIME_USAGE_SUMMARY_V
WHERE MODULE = 'DB_BIG_TABLE_CACHE_EXPERIMENT'
AND CLIENT_INFO = 'SINGLE_TABLE_ANALYTICS_V1'
AND PARALLEL_DEGREE_POLICY = 'POLICY = ADAPTIVE'
)

SELECT
  C.MODULE,
  C.CLIENT_INFO,
  C.SQL_EXEC_START,
  C.RUN_NUMBER,
  C.PARALLEL_DEGREE_POLICY,
  C.BT_CACHE_TARGET,
  A.*
FROM CAPSTONE_DEMO.SGASTAT_HISTORY A
  INNER JOIN EXPERIMENT_FILTER C
    ON A.SNAPSHOT_TS BETWEEN C.SQL_EXEC_START AND C.SQL_EXEC_END
ORDER BY
  A.SNAPSHOT_TS;

SELECT
  *
FROM CAPSTONE_DEMO.SGASTAT_HISTORY;