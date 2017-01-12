

alter session set tracefile_identifier= '10390_TRACE_3'; 
alter session set timed_statistics = true;
alter session set statistics_level=all;
alter session set max_dump_file_size = unlimited;
ALTER SESSION SET EVENTS '10046 trace name context forever, level 12';
ALTER SESSION SET EVENTS '10391 trace name context forever, level 0x0004';
alter session set events 'sql_trace level 12'; --sql_trace is the 10046 trace
  
CREATE OR REPLACE VIEW CAPSTONE_DEMO.SINGLE_TABLE_ORDER_BY_V AS

SELECT
  *
FROM CAPSTONE_DEMO.CAPSTONE_PARALLEL_TEST_V1
ORDER BY
  PRESS_LOCAL_TIME;
  
SELECT /*+ MONITOR PARALLEL(2) GATHER_PLAN_STATISTICS FIND_ME */
  * 
FROM CAPSTONE_DEMO.SINGLE_TABLE_ORDER_BY_V;
  
CREATE OR REPLACE VIEW CAPSTONE_DEMO.SINGLE_TABLE_ANALYTICS_V AS

SELECT 
  DEVICE_ID,
  AVG(MEASUREMENT) AS AVG_MEASUREMENT
FROM CAPSTONE_DEMO.CAPSTONE_PARALLEL_TEST_V1
GROUP BY
  DEVICE_ID;
  
SELECT /*+ MONITOR PARALLEL(2) GATHER_PLAN_STATISTICS FIND_ME */
  * 
FROM CAPSTONE_DEMO.SINGLE_TABLE_ANALYTICS_V;

SELECT
(SELECT
  COUNT(*)
FROM CAPSTONE_DEMO.CHILD_TABLE_V1)/

(SELECT
  COUNT(*)
FROM CAPSTONE_DEMO.PARENT_TABLE_V1) AS TOTAL_LOOPS
FROM DUAL;