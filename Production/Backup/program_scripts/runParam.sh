#!/bin/bash

# runParam.sh
# Alters session and system setting according to the parameter (PRM)
# files that are within each passed experiemnt directory.

# Store passed arguments
logDir=$1
dataDir=$2
expScript=$3
dbUser=$4
password=$5
db=$6

#echo -e '\n\n--------------------------'
#echo 'runParam.sh Input Vars'
#echo 'logDir: ' $logDir
#echo 'dataDir: ' $dataDir
#echo 'dbuser: ' $dbUser
#echo 'db: ' $db
#echo -e '--------------------------\n\n'

# Establish connection and execute predefined queries
sqlplus /nolog <<EOF >> ${logDir}/runTest.log 
CONN ${dbUser}/${password}@${db} as sysdba

@${expScript}

EOF


echo 'Parameters Altered -- ' ${expScript} >> lock.txt 2>&1

