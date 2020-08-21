#!/bin/sh

# Usage: $0 start-time stop-time
START=$1
STOP=$2

METRICSFILE="/data/metrics.log"

# Selecting the timestamp range we need
echo "cpu-user cpu-nice cpu-system cpu-iowait cpu-steal memory-used timestamp"
awk '$7 >= '$START' && $7 <= '$STOP "$METRICSFILE" 


# awk '$7 >= '$START' && $7 <= '$STOP "$METRICSFILE" \
# 	| awk '
# 		{
# 			M+=$6;U+=$1;N+=$2;S+=$3;I+=$4;T+=$5;
# 			print $0
# 		} 
# 		END {
# 			print "============================================================================"
# 			print "cpu-user cpu-nice cpu-system cpu-iowait cpu-steal memory-used records-number"; 
# 			printf "%.2f %.2f %.2f %.2f %.2f %d %d\n",U/NR,N/NR,S/NR,I/NR,T/NR,M/NR,NR
# 		}
# 		'
