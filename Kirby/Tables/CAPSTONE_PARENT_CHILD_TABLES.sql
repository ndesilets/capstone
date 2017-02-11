ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 2147483647;

/*
1)  Create a simple parent table that we can use to join with a child table and check performance
2)  Create a sequence and a trigger so we can auto-generate the parent keys
3)  Insert rows into PARENT_TABLE (takes about 45 minutes to do 1 year)
4)  Create a unique index on PARENT_KEY called PARENT_KEY_UNQ
5)  Alter table to create a unique constraint on PARENT_KEY.  This is required to create a foreign key constraint.
6)  Collect stats on table
*/

DROP TABLE CAPSTONE_DEMO.PARENT_TABLE_V1;
ALTER TABLE CAPSTONE_DEMO.CHILD_TABLE_V1 DROP CONSTRAINT PARENT_KEY_FK;
TRUNCATE TABLE CAPSTONE_DEMO.PARENT_TABLE_V1;
CREATE TABLE CAPSTONE_DEMO.PARENT_TABLE_V1

(
PARENT_KEY NUMBER,
DEVICE_KEY NUMBER,
DEVICE_LOCAL_TIME DATE
)
PCTFREE 0
NOLOGGING
NOCOMPRESS
PARALLEL (DEGREE DEFAULT);

DROP SEQUENCE CAPSTONE_DEMO.PARENT_TABLE_SEQUENCE;
CREATE SEQUENCE CAPSTONE_DEMO.PARENT_TABLE_SEQUENCE;

--DROP TRIGGER CAPSTONE_DEMO.PARENT_TABLE_TRIGGER;
CREATE OR REPLACE TRIGGER CAPSTONE_DEMO.PARENT_TABLE_TRIGGER
BEFORE INSERT ON CAPSTONE_DEMO.PARENT_TABLE_V1 FOR EACH ROW

BEGIN
  IF :NEW.PARENT_KEY IS NULL THEN
    SELECT PARENT_TABLE_SEQUENCE.NEXTVAL
    INTO :NEW.PARENT_KEY 
    FROM DUAL;
  END IF;
END;

BEGIN

FOR A IN 11..26 LOOP
FOR B IN 1..10 LOOP

INSERT INTO CAPSTONE_DEMO.PARENT_TABLE_V1

(
DEVICE_KEY,
DEVICE_LOCAL_TIME
)

SELECT
  A AS DEVICE_KEY,
  TO_DATE('20160101 00:00:00', 'yyyymmdd hh24:mi:ss') + (B-1)*36.5 + ROWNUM/24/60/60*10 - 1/24/60/60 AS DEVICE_LOCAL_TIME
FROM DUAL
CONNECT BY LEVEL <= 315360;
  
COMMIT;

END LOOP;
END LOOP;
END;
/
DROP INDEX PARENT_KEY_UNQ;
CREATE UNIQUE INDEX PARENT_KEY_UNQ ON CAPSTONE_DEMO.PARENT_TABLE_V1(PARENT_KEY);
ALTER TABLE CAPSTONE_DEMO.PARENT_TABLE_V1 ADD CONSTRAINT PARENT_KEY_UNQ UNIQUE(PARENT_KEY);

BEGIN -- Gather Stats

DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'CAPSTONE_DEMO', TABNAME => 'PARENT_TABLE_V1', GRANULARITY => 'ALL', ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, DEGREE => 16, CASCADE => DBMS_STATS.AUTO_CASCADE);

END;
/


/*
1)  Create a child table that has a one to many relationship with the parent table
2)  Insert 100 child records for each parent record
3)  Alter table to add the foreign key constraint
*/

DROP TABLE CAPSTONE_DEMO.CHILD_TABLE_V1;
TRUNCATE TABLE CAPSTONE_DEMO.CHILD_TABLE_V1;
CREATE TABLE CAPSTONE_DEMO.CHILD_TABLE_V1

(
PARENT_KEY NUMBER,
LOCATION_KEY NUMBER,
MEASUREMENT_VALUE NUMBER
)
PCTFREE 0
NOLOGGING
NOCOMPRESS
PARALLEL (DEGREE DEFAULT);

ALTER TABLE CAPSTONE_DEMO.CHILD_TABLE_V1 
  ADD CONSTRAINT PARENT_KEY_FK 
  FOREIGN KEY (PARENT_KEY)
  REFERENCES CAPSTONE_DEMO.PARENT_TABLE_V1(PARENT_KEY) ON DELETE CASCADE;


/
BEGIN

FOR A IN 1..100 LOOP

INSERT INTO CAPSTONE_DEMO.CHILD_TABLE_V1

SELECT
  A.PARENT_KEY,
  A AS LOCATION_KEY,
  ORA_HASH(A || SYSDATE) AS MEASUREMENT_VALUE
FROM CAPSTONE_DEMO.PARENT_TABLE_V1 A;

COMMIT;

END LOOP;
END;

BEGIN -- Gather Stats

DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'CAPSTONE_DEMO', TABNAME => 'CHILD_TABLE_V1', GRANULARITY => 'ALL', ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, DEGREE => 16, CASCADE => DBMS_STATS.AUTO_CASCADE);

END;
/
SELECT
  *
FROM CAPSTONE_DEMO.PARENT_TABLE_V1
ORDER BY
  PARENT_KEY;

SELECT
  *
FROM CAPSTONE_DEMO.CHILD_TABLE_V1;