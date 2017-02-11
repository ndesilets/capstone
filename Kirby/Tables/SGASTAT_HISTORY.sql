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