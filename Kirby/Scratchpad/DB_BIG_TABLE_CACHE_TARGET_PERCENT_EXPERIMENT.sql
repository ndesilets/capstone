ALTER SESSION SET CONTAINER = CDB$ROOT;
ALTER SYSTEM SET "_PGA_MAX_SIZE" = 4G;
ALTER SYSTEM SET DB_CACHE_SIZE = 92G;
ALTER SYSTEM SET PARALLEL_DEGREE_POLICY = MANUAL;
ALTER SYSTEM SET DB_BIG_TABLE_CACHE_PERCENT_TARGET = 10;
ALTER SESSION SET CONTAINER = DBCAP;
EXECUTE CAPSTONE_DEMO.RESOURCE_MONITOR.PARAMETERS_HISTORY_INSERT;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'DB_BIG_TABLE_CACHE_EXPERIMENT',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'SINGLE_TABLE_ANALYTICS_V1');
END;
/
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.SINGLE_TABLE_ANALYTICS_V1; --Run 1
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.SINGLE_TABLE_ANALYTICS_V1; --Run 2
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.SINGLE_TABLE_ANALYTICS_V1; --Run 3

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'PARENT_CHILD_ANALYTICS_V1');
END;
/
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.PARENT_CHILD_ANALYTICS_V1; --Run 1
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.PARENT_CHILD_ANALYTICS_V1; --Run 2
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.PARENT_CHILD_ANALYTICS_V1; --Run 3

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'LEAD_LAG_V1');
END;
/

SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.LEAD_LAG_V1; --Run 1
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.LEAD_LAG_V1; --Run 2
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.LEAD_LAG_V1; --Run 3

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'FILTER_PARENT_CHILD_JOIN_V1');
END;
/

SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.FILTER_PARENT_CHILD_JOIN_V1; --Run 1
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.FILTER_PARENT_CHILD_JOIN_V1; --Run 2
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.FILTER_PARENT_CHILD_JOIN_V1; --Run 3

ALTER SESSION SET CONTAINER = CDB$ROOT;
ALTER SYSTEM SET "_PGA_MAX_SIZE" = 4G;
ALTER SYSTEM SET DB_CACHE_SIZE = 92G;
ALTER SYSTEM SET PARALLEL_DEGREE_POLICY = MANUAL;
ALTER SYSTEM SET DB_BIG_TABLE_CACHE_PERCENT_TARGET = 50;
ALTER SESSION SET CONTAINER = DBCAP;
EXECUTE CAPSTONE_DEMO.RESOURCE_MONITOR.PARAMETERS_HISTORY_INSERT;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'DB_BIG_TABLE_CACHE_EXPERIMENT',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'SINGLE_TABLE_ANALYTICS_V1');
END;
/
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.SINGLE_TABLE_ANALYTICS_V1; --Run 1
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.SINGLE_TABLE_ANALYTICS_V1; --Run 2
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.SINGLE_TABLE_ANALYTICS_V1; --Run 3

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'PARENT_CHILD_ANALYTICS_V1');
END;
/
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.PARENT_CHILD_ANALYTICS_V1; --Run 1
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.PARENT_CHILD_ANALYTICS_V1; --Run 2
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.PARENT_CHILD_ANALYTICS_V1; --Run 3

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'LEAD_LAG_V1');
END;
/

SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.LEAD_LAG_V1; --Run 1
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.LEAD_LAG_V1; --Run 2
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.LEAD_LAG_V1; --Run 3

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'FILTER_PARENT_CHILD_JOIN_V1');
END;
/

SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.FILTER_PARENT_CHILD_JOIN_V1; --Run 1
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.FILTER_PARENT_CHILD_JOIN_V1; --Run 2
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.FILTER_PARENT_CHILD_JOIN_V1; --Run 3

ALTER SESSION SET CONTAINER = CDB$ROOT;
ALTER SYSTEM SET "_PGA_MAX_SIZE" = 4G;
ALTER SYSTEM SET DB_CACHE_SIZE = 92G;
ALTER SYSTEM SET PARALLEL_DEGREE_POLICY = MANUAL;
ALTER SYSTEM SET DB_BIG_TABLE_CACHE_PERCENT_TARGET = 90;
ALTER SESSION SET CONTAINER = DBCAP;
EXECUTE CAPSTONE_DEMO.RESOURCE_MONITOR.PARAMETERS_HISTORY_INSERT;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'DB_BIG_TABLE_CACHE_EXPERIMENT',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'SINGLE_TABLE_ANALYTICS_V1');
END;
/
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.SINGLE_TABLE_ANALYTICS_V1; --Run 1
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.SINGLE_TABLE_ANALYTICS_V1; --Run 2
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.SINGLE_TABLE_ANALYTICS_V1; --Run 3

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'PARENT_CHILD_ANALYTICS_V1');
END;
/
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.PARENT_CHILD_ANALYTICS_V1; --Run 1
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.PARENT_CHILD_ANALYTICS_V1; --Run 2
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.PARENT_CHILD_ANALYTICS_V1; --Run 3

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'LEAD_LAG_V1');
END;
/

SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.LEAD_LAG_V1; --Run 1
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.LEAD_LAG_V1; --Run 2
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.LEAD_LAG_V1; --Run 3

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'FILTER_PARENT_CHILD_JOIN_V1');
END;
/

SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.FILTER_PARENT_CHILD_JOIN_V1; --Run 1
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.FILTER_PARENT_CHILD_JOIN_V1; --Run 2
SELECT /*+ PARALLEL(16) */ * FROM CAPSTONE_DEMO.FILTER_PARENT_CHILD_JOIN_V1; --Run 3