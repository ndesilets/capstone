CREATE TABLE CAPSTONE_DEMO.RESOURCE_MONITOR_STATUS

(
STATUS VARCHAR2(5)
);

INSERT INTO CAPSTONE_DEMO.RESOURCE_MONITOR_STATUS(STATUS) VALUES('TRUE');
COMMIT;

TRUNCATE TABLE CAPSTONE_DEMO.RESOURCE_MONITOR_STATUS;