BEGIN

DBMS_APPLICATION_INFO.SET_MODULE
(
  MODULE_NAME => 'EXPERIMENT_NATE_SUITE_V1',
  ACTION_NAME => 'RESOURCE_MONITORING'
);

END;
/

BEGIN
DBMS_APPLICATION_INFO.SET_CLIENT_INFO (client_info => 'SINGLE_TABLE_ANALYTICS_V1');
END;
/

SELECT /*+ PARALLEL(16) */
  *
FROM CAPSTONE_DEMO.SINGLE_TABLE_ANALYTICS_V1;

BEGIN
DBMS_APPLICATION_INFO.SET_CLIENT_INFO (client_info => 'PARENT_CHILD_ANALYTICS_V1');
END;
/

SELECT /*+ PARALLEL(16) */
  *
FROM CAPSTONE_DEMO.PARENT_CHILD_ANALYTICS_V1;

BEGIN
DBMS_APPLICATION_INFO.SET_CLIENT_INFO (client_info => 'LEAD_LAG_V1');
END;
/

SELECT /*+ PARALLEL(16) */
  *
FROM CAPSTONE_DEMO.LEAD_LAG_V1;

BEGIN
DBMS_APPLICATION_INFO.SET_CLIENT_INFO (client_info => 'FILTER_PARENT_CHILD_JOIN_V1');
END;
/

SELECT /*+ PARALLEL(16) */
  *
FROM CAPSTONE_DEMO.FILTER_PARENT_CHILD_JOIN_V1;


