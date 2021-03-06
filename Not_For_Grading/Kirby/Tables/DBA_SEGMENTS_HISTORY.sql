TRUNCATE TABLE CAPSTONE_DEMO.DBA_SEGMENTS_HISTORY;
DROP TABLE CAPSTONE_DEMO.DBA_SEGMENTS_HISTORY;
CREATE TABLE CAPSTONE_DEMO.DBA_SEGMENTS_HISTORY

(
SNAPSHOT_TS TIMESTAMP,
OWNER VARCHAR2(128),
SEGMENT_NAME VARCHAR2(128),
PARTITION_NAME VARCHAR2(128),
SEGMENT_TYPE VARCHAR2(18),
SEGMENT_SUBTYPE VARCHAR2(10),
TABLESPACE_NAME VARCHAR2(30),
HEADER_FILE NUMBER,
HEADER_BLOCK NUMBER,
BYTES NUMBER,
BLOCKS NUMBER,
EXTENTS NUMBER,
INITIAL_EXTENT NUMBER,
NEXT_EXTENT NUMBER,
MIN_EXTENTS NUMBER,
MAX_EXTENTS NUMBER,
MAX_SIZE NUMBER,
RETENTION VARCHAR2(7),
MINRETENTION NUMBER,
PCT_INCREASE NUMBER,
FREELISTS NUMBER,
FREELIST_GROUPS NUMBER,
RELATIVE_FNO NUMBER,
BUFFER_POOL VARCHAR2(7),
FLASH_CACHE VARCHAR2(7),
CELL_FLASH_CACHE VARCHAR2(7),
INMEMORY VARCHAR2(8),
INMEMORY_PRIORITY VARCHAR2(8),
INMEMORY_DISTRIBUTE VARCHAR2(15),
INMEMORY_DUPLICATE VARCHAR2(13),
INMEMORY_COMPRESSION VARCHAR2(17)
);

INSERT INTO CAPSTONE_DEMO.DBA_SEGMENTS_HISTORY

SELECT
  SYSTIMESTAMP AS SNAPSHOT_TS,
  A.OWNER,
A.SEGMENT_NAME,
A.PARTITION_NAME,
A.SEGMENT_TYPE,
A.SEGMENT_SUBTYPE,
A.TABLESPACE_NAME,
A.HEADER_FILE,
A.HEADER_BLOCK,
A.BYTES,
A.BLOCKS,
A.EXTENTS,
A.INITIAL_EXTENT,
A.NEXT_EXTENT,
A.MIN_EXTENTS,
A.MAX_EXTENTS,
A.MAX_SIZE,
A.RETENTION,
A.MINRETENTION,
A.PCT_INCREASE,
A.FREELISTS,
A.FREELIST_GROUPS,
A.RELATIVE_FNO,
A.BUFFER_POOL,
A.FLASH_CACHE,
A.CELL_FLASH_CACHE,
A.INMEMORY,
A.INMEMORY_PRIORITY,
A.INMEMORY_DISTRIBUTE,
A.INMEMORY_DUPLICATE,
A.INMEMORY_COMPRESSION
FROM DBA_SEGMENTS A
WHERE OWNER = 'CAPSTONE_DEMO';

COMMIT;