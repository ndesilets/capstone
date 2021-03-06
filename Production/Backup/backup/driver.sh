#!/bin/bash

# This script sets up the environment needed to run a stat monitoring
# loop in the background as well as run a series of sql tests

# Usage statement
if [ ! $# == 3 ]; then
    echo 'Usage: ./driver.sh <snapFreq> <expScript> <moduleName> [user]'
    exit 1
fi

# Set up oracle env variables
export ORACLE_SID=capstone
export ORAENV_ASK=NO
. oraenv

# Import user credentials
source ./dbconfig.cfg

# Set up local variables
snapFreq=${1}
#expScript=$( cat ${2} ) # Trying to pass contents of experiment script
moduleName=${2}
logDir='../logs'
dataDir='../data'

# Create file system
if [ ! -d ${logDir} ]; then
    mkdir ${logDir}
    echo 'Created ' ${logDir}
fi

if [ ! -d ${dataDir} ]; then
    mkdir ${dataDir}
    echo 'Created ' ${dataDir}
fi

# Branch of to run monitor and test
echo 'Starting Monitoring Loop -- snapFreq: ' ${snapFreq}
./runMonitor.sh ${logDir} ${dataDir} ${snapFreq} ${dbUser} ${password} ${db} &

echo 'Starting Experiment Suite -- moduleName: ' ${moduleName}
./runTest.sh ${logDir} ${dataDir} ${moduleName} ${dbUser} ${password} ${db}

# Remove environmental variables
unset ${ORAENV_ASK}

# Add code to query flag table to stop
# the monitor loop

echo 'Experimentation completed'

