module.exports = (id) => {
    return `
-- Kirby Sand
WITH FINDING_SID AS

(
SELECT DISTINCT 
    LAST_VALUE(SID) OVER(ORDER BY LAST_REFRESH_TIME ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS SID,
    LAST_VALUE(SQL_ID) OVER(ORDER BY LAST_REFRESH_TIME ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS SQL_ID
FROM V$SQL_MONITOR 
WHERE SQL_TEXT LIKE '${id}'
),

TESTING AS

(
SELECT 
    B.QCSID,
    B.SID,
    A.STAT_NAME,
    A.VALUE
FROM V$SESS_TIME_MODEL A
    INNER JOIN V$PX_SESSION B
        ON A.SID = B.SID
WHERE B.QCSID = (SELECT SID FROM FINDING_SID)
),

TESTING_PIVOT AS

(
SELECT
    *
FROM TESTING
PIVOT (
    SUM(VALUE)
    FOR STAT_NAME IN ('DB time' AS DB_TIME, 'sql execute elapsed time' AS ELAPSED_TIME, 'DB CPU' AS CPU_TIME)
    )
)

SELECT
    QCSID,
    SID,
    DB_TIME/1E6 AS DB_TIME_SEC,
    ELAPSED_TIME/1E6 AS ELAPSED_TIME_SEC,
    CPU_TIME/1E6 AS CPU_TIME_SEC
FROM TESTING_PIVOT A
ORDER BY
    QCSID,
    ELAPSED_TIME_SEC DESC
    `;
};