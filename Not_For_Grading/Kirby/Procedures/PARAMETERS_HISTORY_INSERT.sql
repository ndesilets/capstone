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

INSERT INTO CAPSTONE_DEMO.ALL_TABLES_HISTORY

SELECT
  SYSTIMESTAMP AS SNAPSHOT_TS,
  A.OWNER,
  A.TABLE_NAME,
  A.TABLESPACE_NAME,
  A.CLUSTER_NAME,
  A.IOT_NAME,
  A.STATUS,
  A.PCT_FREE,
  A.PCT_USED,
  A.INI_TRANS,
  A.MAX_TRANS,
  A.INITIAL_EXTENT,
  A.NEXT_EXTENT,
  A.MIN_EXTENTS,
  A.MAX_EXTENTS,
  A.PCT_INCREASE,
  A.FREELISTS,
  A.FREELIST_GROUPS,
  A.LOGGING,
  A.BACKED_UP,
  A.NUM_ROWS,
  A.BLOCKS,
  A.EMPTY_BLOCKS,
  A.AVG_SPACE,
  A.CHAIN_CNT,
  A.AVG_ROW_LEN,
  A.AVG_SPACE_FREELIST_BLOCKS,
  A.NUM_FREELIST_BLOCKS,
  A.DEGREE,
  A.INSTANCES,
  A.CACHE,
  A.TABLE_LOCK,
  A.SAMPLE_SIZE,
  A.LAST_ANALYZED,
  A.PARTITIONED,
  A.IOT_TYPE,
  A.TEMPORARY,
  A.SECONDARY,
  A.NESTED,
  A.BUFFER_POOL,
  A.FLASH_CACHE,
  A.CELL_FLASH_CACHE,
  A.ROW_MOVEMENT,
  A.GLOBAL_STATS,
  A.USER_STATS,
  A.DURATION,
  A.SKIP_CORRUPT,
  A.MONITORING,
  A.CLUSTER_OWNER,
  A.DEPENDENCIES,
  A.COMPRESSION,
  A.COMPRESS_FOR,
  A.DROPPED,
  A.READ_ONLY,
  A.SEGMENT_CREATED,
  A.RESULT_CACHE,
  A.CLUSTERING,
  A.ACTIVITY_TRACKING,
  A.DML_TIMESTAMP,
  A.HAS_IDENTITY,
  A.CONTAINER_DATA,
  A.INMEMORY,
  A.INMEMORY_PRIORITY,
  A.INMEMORY_DISTRIBUTE,
  A.INMEMORY_COMPRESSION,
  A.INMEMORY_DUPLICATE
FROM ALL_TABLES A
WHERE OWNER = 'CAPSTONE_DEMO';

COMMIT;

INSERT INTO CAPSTONE_DEMO.ALL_TAB_COLS_HISTORY

SELECT
  SYSTIMESTAMP SNAPSHOT_TS,
  A.OWNER,
  A.TABLE_NAME,
  A.COLUMN_NAME,
  A.DATA_TYPE,
  A.DATA_TYPE_MOD,
  A.DATA_TYPE_OWNER,
  A.DATA_LENGTH,
  A.DATA_PRECISION,
  A.DATA_SCALE,
  A.NULLABLE,
  A.COLUMN_ID,
  A.DEFAULT_LENGTH,
  A.NUM_DISTINCT,
  A.LOW_VALUE,
  A.HIGH_VALUE,
  A.DENSITY,
  A.NUM_NULLS,
  A.NUM_BUCKETS,
  A.LAST_ANALYZED,
  A.SAMPLE_SIZE,
  A.CHARACTER_SET_NAME,
  A.CHAR_COL_DECL_LENGTH,
  A.GLOBAL_STATS,
  A.USER_STATS,
  A.AVG_COL_LEN,
  A.CHAR_LENGTH,
  A.CHAR_USED,
  A.V80_FMT_IMAGE,
  A.DATA_UPGRADED,
  A.HIDDEN_COLUMN,
  A.VIRTUAL_COLUMN,
  A.SEGMENT_COLUMN_ID,
  A.INTERNAL_COLUMN_ID,
  A.HISTOGRAM,
  A.QUALIFIED_COL_NAME,
  A.USER_GENERATED,
  A.DEFAULT_ON_NULL,
  A.IDENTITY_COLUMN,
  A.EVALUATION_EDITION,
  A.UNUSABLE_BEFORE,
  A.UNUSABLE_BEGINNING
FROM ALL_TAB_COLS A
WHERE OWNER = 'CAPSTONE_DEMO';

COMMIT;

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

INSERT INTO CAPSTONE_DEMO.DBA_INDEXES_HISTORY

SELECT
  SYSTIMESTAMP AS SNAPSHOT_TS,
  A.OWNER,
  A.INDEX_NAME,
  A.INDEX_TYPE,
  A.TABLE_OWNER,
  A.TABLE_NAME,
  A.TABLE_TYPE,
  A.UNIQUENESS,
  A.COMPRESSION,
  A.PREFIX_LENGTH,
  A.TABLESPACE_NAME,
  A.INI_TRANS,
  A.MAX_TRANS,
  A.INITIAL_EXTENT,
  A.NEXT_EXTENT,
  A.MIN_EXTENTS,
  A.MAX_EXTENTS,
  A.PCT_INCREASE,
  A.PCT_THRESHOLD,
  A.INCLUDE_COLUMN,
  A.FREELISTS,
  A.FREELIST_GROUPS,
  A.PCT_FREE,
  A.LOGGING,
  A.BLEVEL,
  A.LEAF_BLOCKS,
  A.DISTINCT_KEYS,
  A.AVG_LEAF_BLOCKS_PER_KEY,
  A.AVG_DATA_BLOCKS_PER_KEY,
  A.CLUSTERING_FACTOR,
  A.STATUS,
  A.NUM_ROWS,
  A.SAMPLE_SIZE,
  A.LAST_ANALYZED,
  A.DEGREE,
  A.INSTANCES,
  A.PARTITIONED,
  A.TEMPORARY,
  A.GENERATED,
  A.SECONDARY,
  A.BUFFER_POOL,
  A.FLASH_CACHE,
  A.CELL_FLASH_CACHE,
  A.USER_STATS,
  A.DURATION,
  A.PCT_DIRECT_ACCESS,
  A.ITYP_OWNER,
  A.ITYP_NAME,
  A.PARAMETERS,
  A.GLOBAL_STATS,
  A.DOMIDX_STATUS,
  A.DOMIDX_OPSTATUS,
  A.FUNCIDX_STATUS,
  A.JOIN_INDEX,
  A.IOT_REDUNDANT_PKEY_ELIM,
  A.DROPPED,
  A.VISIBILITY,
  A.DOMIDX_MANAGEMENT,
  A.SEGMENT_CREATED,
  A.ORPHANED_ENTRIES,
  A.INDEXING
FROM DBA_INDEXES A
WHERE OWNER = 'CAPSTONE_DEMO';

COMMIT;

INSERT INTO CAPSTONE_DEMO.IM_COLUMN_LEVEL_HISTORY

SELECT
SYSTIMESTAMP AS SNAPSHOT_TS,
NULL AS SNAPSHOT_ID,
A.INST_ID,
A.OWNER,
A.OBJ_NUM,
A.TABLE_NAME,
A.SEGMENT_COLUMN_ID,
A.COLUMN_NAME,
A.INMEMORY_COMPRESSION,
A.CON_ID
FROM V$IM_COLUMN_LEVEL A;

COMMIT;

END PARAMETERS_HISTORY_INSERT;