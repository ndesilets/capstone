ALTER SESSION SET DB_FILE_MULTIBLOCK_READ_COUNT=32;
ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 2147483647;
ALTER SESSION SET HASH_AREA_SIZE = 2147483647;
ALTER SESSION ENABLE PARALLEL DML;
ALTER SESSION SET CONTAINER = dbcap;
-- Set up table
DROP TABLE dr_part_date_day_interval;

CREATE TABLE  dr_part_date_day_interval
PARTITION BY RANGE (press_local_time) 
  INTERVAL (numtodsinterval(1,'DAY')) 
  (PARTITION part_01 VALUES LESS THAN (to_date('01/02/2007', 'MM/DD/YYYY'))) 
AS (SELECT DISTINCT device_id, press_local_time, measurement_type_key, measurement 
  FROM whitlocn.capstone_two_billion 
  WHERE (device_id IN ('11', '12','15','16','19','24') AND press_local_time < to_date(20171220, 'yyyymmdd'))
    OR (device_id IN ('14','23','20','25','26') AND press_local_time < to_date(20161212, 'yyyymmdd')
    OR (device_id IN ('13','17','18','21','22') AND press_local_time < to_date(20161221, 'yyyymmdd'))));

--------------------------------------------------------------------------------
-- DL with only new values
--------------------------------------------------------------------------------
-- 0.05% of DR
DROP TABLE data_loader;
CREATE TABLE data_loader AS (SELECT DISTINCT device_id, press_local_time, measurement_type_key, measurement 
FROM whitlocn.capstone_two_billion
  WHERE (device_id IN ('11', '12','15','16','19','24') AND press_local_time >= to_date(20171220, 'yyyymmdd'))
    OR (device_id IN ('14','23','20','25','26') AND press_local_time >= to_date(20161212, 'yyyymmdd')
    OR (device_id IN ('13','17','18','21','22') AND press_local_time >= to_date(20161221, 'yyyymmdd'))));
    
--------------------------------------------------------------------------------
-- No-Index experiment
--------------------------------------------------------------------------------
EXECUTE CAPSTONE_DEMO.RESOURCE_MONITOR.PARAMETERS_HISTORY_INSERT;
BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_DAY_NEW_DATA_NOI',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_NUI.sql dr_part_date_day_interval

-- GLOBAL INDEX EXPERIMENTS
--------------------------------------------------------------------------------
-- Primary key experiment (Prefix)
--------------------------------------------------------------------------------
ALTER TABLE dr_part_date_day_interval DROP CONSTRAINT prefix_key;
ALTER TABLE dr_part_date_day_interval ADD CONSTRAINT prefix_key PRIMARY KEY(press_local_time,device_id, measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_DAY_NEW_DATA_PK_P',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_Date_Pre_UI.sql dr_part_date_day_interval

ALTER TABLE dr_part_date_day_interval DROP CONSTRAINT prefix_key;
----------------------------------------------------------------------------------
---- Primary key experiment (Non-prefix)
----------------------------------------------------------------------------------
ALTER TABLE dr_part_date_day_interval DROP CONSTRAINT non_prefix_key;
ALTER TABLE dr_part_date_day_interval ADD CONSTRAINT non_prefix_key PRIMARY KEY(device_id, press_local_time,  measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_DAY_NEW_DATA_PK_NP',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_ID_Pre_UI.sql dr_part_date_day_interval

ALTER TABLE dr_part_date_day_interval DROP CONSTRAINT non_prefix_key;
----------------------------------------------------------------------------------
---- Unique index experiment (Prefix)
----------------------------------------------------------------------------------
DROP INDEX unique_P_index;
CREATE UNIQUE INDEX unique_P_index ON dr_part_date_day_interval(press_local_time,device_id, measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_DAY_NEW_DATA_UI_P',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_Date_Pre_UI.sql dr_part_date_day_interval

DROP INDEX unique_P_index;
----------------------------------------------------------------------------------
---- Unique index experiment (Non-prefix)
----------------------------------------------------------------------------------
ALTER SYSTEM FLUSH SHARED_POOL;
DROP INDEX unique_NP_index;
CREATE UNIQUE INDEX unique_NP_index ON dr_part_date_day_interval(device_id, press_local_time,  measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_DAY_NEW_DATA_UI_NP',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_ID_Pre_UI.sql dr_part_date_day_interval

DROP INDEX unique_NP_index;
--------------------------------------------------------------------------------
-- Nonunique index experiment (Prefix)
--------------------------------------------------------------------------------
DROP INDEX nonunique_P_index;
CREATE INDEX nonunique_P_index ON dr_part_date_day_interval(press_local_time, device_id, measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_DAY_NEW_DATA_NUI_P',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_NUI.sql dr_part_date_day_interval

DROP INDEX nonunique_P_index;
--------------------------------------------------------------------------------
-- Nonunique index experiment (Non-prefix)
--------------------------------------------------------------------------------
ALTER SYSTEM FLUSH SHARED_POOL;
DROP INDEX nonunique_NP_index;
CREATE INDEX nonunique_NP_index ON dr_part_date_day_interval(device_id, press_local_time,  measurement_type_key, measurement);

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_DAY_NEW_DATA_NUI_NP',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_NUI.sql dr_part_date_day_interval

DROP INDEX nonunique_NP_index;

-- LOCAL INDEX EXPERIMENTS
--------------------------------------------------------------------------------
-- Unique index (Prefix)
--------------------------------------------------------------------------------
DROP INDEX local_prefix_unique;
CREATE UNIQUE INDEX local_prefix_unique ON dr_part_date_day_interval(press_local_time, device_id, measurement_type_key, measurement) LOCAL;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_DAY_NEW_DATA_LUI_P',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_Date_Pre_UI.sql dr_part_date_day_interval

DROP INDEX local_prefix_unique;
--------------------------------------------------------------------------------
-- Unique index (Non-prefix)
--------------------------------------------------------------------------------
DROP INDEX local_nonprefix_unique;
CREATE UNIQUE INDEX local_nonprefix_unique ON dr_part_date_day_interval(device_id, press_local_time, measurement_type_key, measurement) LOCAL;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_DAY_NEW_DATA_LUI_NP',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_ID_Pre_UI.sql dr_part_date_day_interval

DROP INDEX local_nonprefix_unique;

--------------------------------------------------------------------------------
-- Non-unique index (Prefix)
--------------------------------------------------------------------------------
DROP INDEX local_prefix_nonunique;
CREATE INDEX local_prefix_nonunique ON dr_part_date_day_interval(press_local_time, device_id, measurement_type_key, measurement) LOCAL;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_DAY_NEW_DATA_LNUI_P',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_NUI.sql dr_part_date_day_interval

DROP INDEX local_prefix_nonunique;
--------------------------------------------------------------------------------
-- Non-unqiue index (Non-prefix)
--------------------------------------------------------------------------------
DROP INDEX local_nonprefix_nonunique;
CREATE INDEX local_nonprefix_nonunique ON dr_part_date_day_interval(device_id, press_local_time, measurement_type_key, measurement) LOCAL;

BEGIN
  DBMS_LOCK.SLEEP(SECONDS => 30);
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'PART_BY_DAY_NEW_DATA_LNUI_NP',ACTION_NAME => 'RESOURCE_MONITORING'); 
  DBMS_APPLICATION_INFO.SET_CLIENT_INFO(CLIENT_INFO => 'STANDARD_QUERY');
END;
/

@index_tests/Tests_NUI.sql dr_part_date_day_interval

DROP INDEX local_nonprefix_nonunique;

DROP TABLE dr_part_date_day_interval;