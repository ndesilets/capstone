DROP TABLE CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS;
TRUNCATE TABLE CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS;
CREATE TABLE CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS

(
EXPERIMENT_NUMBER NUMBER,
CHANGE_TYPE VARCHAR2(64),
PARAMETER_NAME VARCHAR2(64),
SCOPE_STATEMENT VARCHAR2(64),
RESTART_REQUIRED VARCHAR2(64),
PARAMETER_VALUE VARCHAR2(64)
);

INSERT INTO CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS (EXPERIMENT_NUMBER, CHANGE_TYPE, PARAMETER_NAME, SCOPE_STATEMENT, RESTART_REQUIRED, PARAMETER_VALUE) VALUES(1, 'ALTER SYSTEM', 'PGA_AGGREGATE_LIMIT',                  'MEMORY', 'NO', '250G');
INSERT INTO CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS (EXPERIMENT_NUMBER, CHANGE_TYPE, PARAMETER_NAME, SCOPE_STATEMENT, RESTART_REQUIRED, PARAMETER_VALUE) VALUES(1, 'ALTER SYSTEM', 'PGA_AGGREGATE_TARGET',                 'MEMORY', 'NO', '192G');
INSERT INTO CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS (EXPERIMENT_NUMBER, CHANGE_TYPE, PARAMETER_NAME, SCOPE_STATEMENT, RESTART_REQUIRED, PARAMETER_VALUE) VALUES(1, 'ALTER SYSTEM', '_PGA_MAX_SIZE',                        'MEMORY', 'NO', '2G');
INSERT INTO CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS (EXPERIMENT_NUMBER, CHANGE_TYPE, PARAMETER_NAME, SCOPE_STATEMENT, RESTART_REQUIRED, PARAMETER_VALUE) VALUES(1, 'CALCULATED',   'SMM_MAX_SIZE',                         'MEMORY', 'NO', '1G');
INSERT INTO CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS (EXPERIMENT_NUMBER, CHANGE_TYPE, PARAMETER_NAME, SCOPE_STATEMENT, RESTART_REQUIRED, PARAMETER_VALUE) VALUES(1, 'CALCULATED',   '_SMM_PX_MAX_SIZE',                     'MEMORY', 'NO', '32G');
--INSERT INTO CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS (EXPERIMENT_NUMBER, CHANGE_TYPE, PARAMETER_NAME, SCOPE_STATEMENT, RESTART_REQUIRED, PARAMETER_VALUE) VALUES(1, 'CALCULATED',   '_SMM_ISORT_CAP',                       'MEMORY');
--INSERT INTO CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS (EXPERIMENT_NUMBER, CHANGE_TYPE, PARAMETER_NAME, SCOPE_STATEMENT, RESTART_REQUIRED, PARAMETER_VALUE) VALUES(1, 'ALTER SYSTEM', 'SGA_TARGET',                           'MEMORY');
--INSERT INTO CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS (EXPERIMENT_NUMBER, CHANGE_TYPE, PARAMETER_NAME, SCOPE_STATEMENT, RESTART_REQUIRED, PARAMETER_VALUE) VALUES(1, 'ALTER SYSTEM', 'SGA_MAX_SIZE',                         'MEMORY');
--INSERT INTO CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS (EXPERIMENT_NUMBER, CHANGE_TYPE, PARAMETER_NAME, SCOPE_STATEMENT, RESTART_REQUIRED, PARAMETER_VALUE) VALUES(1, 'ALTER SYSTEM', 'DB_CACHE_SIZE',                        'MEMORY');
--INSERT INTO CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS (EXPERIMENT_NUMBER, CHANGE_TYPE, PARAMETER_NAME, SCOPE_STATEMENT, RESTART_REQUIRED, PARAMETER_VALUE) VALUES(1, 'ALTER SYSTEM', 'DB_BIG_TABLE_CACHE_PERCENT_TARGET',    'MEMORY');
--INSERT INTO CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS (EXPERIMENT_NUMBER, CHANGE_TYPE, PARAMETER_NAME, SCOPE_STATEMENT, RESTART_REQUIRED, PARAMETER_VALUE) VALUES(1, 'ALTER SYSTEM', 'PARALLEL_DEGREE_POLICY',               'MEMORY', 'YES', 'MANUAL');
--INSERT INTO CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS (EXPERIMENT_NUMBER, CHANGE_TYPE, PARAMETER_NAME, SCOPE_STATEMENT, RESTART_REQUIRED, PARAMETER_VALUE) VALUES(1, 'ALTER SYSTEM', 'PARALLEL_MIN_TIME_THRESHOLD',          'MEMORY');
--INSERT INTO CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS (EXPERIMENT_NUMBER, CHANGE_TYPE, PARAMETER_NAME, SCOPE_STATEMENT, RESTART_REQUIRED, PARAMETER_VALUE) VALUES(1, 'ALTER SYSTEM', 'INMEMORY_SIZE',          'MEMORY', 'YES', '0');

SELECT
  CHANGE_TYPE || ' SET "' || PARAMETER_NAME || '" = "' || PARAMETER_VALUE || '";' AS ALTER_STATEMENT
FROM CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS
WHERE CHANGE_TYPE <> 'CALCULATED'
AND EXPERIMENT_NUMBER = 1;

SELECT
  *
FROM CAPSTONE_DEMO.DESIGN_OF_EXPERIMENTS;

ALTER SYSTEM SET "PGA_AGGREGATE_LIMIT" = "250G";
ALTER SYSTEM SET "PGA_AGGREGATE_TARGET" = "192G";
ALTER SYSTEM SET "_PGA_MAX_SIZE" = "4G";
