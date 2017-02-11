TRUNCATE TABLE CAPSTONE_DEMO.SGA_DYNAMIC_FREE_MEM_HISTORY;
DROP TABLE CAPSTONE_DEMO.SGA_DYNAMIC_FREE_MEM_HISTORY;
CREATE TABLE CAPSTONE_DEMO.SGA_DYNAMIC_FREE_MEM_HISTORY

(
SNAPSHOT_TS TIMESTAMP,
SNAPSHOT_ID NUMBER,
CURRENT_SIZE NUMBER,
CON_ID NUMBER
);

INSERT INTO CAPSTONE_DEMO.SGA_DYNAMIC_FREE_MEM_HISTORY

SELECT
  SYSTIMESTAMP AS SNAPSHOT_TS,
  NULL AS SNAPSHOT_TS,
  A.CURRENT_SIZE,
  A.CON_ID
FROM V$SGA_DYNAMIC_FREE_MEMORY A;

COMMIT;