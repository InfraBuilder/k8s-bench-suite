#!/bin/sh
# Free -m output sample :
#	              total        used        free      shared  buff/cache   available
#	Mem:          64316        6544       35949         143       21821       58631
#	Swap:             0           0           0
#
# Sar output sample:
#	Linux 4.15.0-101-generic (tokyo)         06/03/2020         _x86_64_        (16 CPU)
#
#	04:09:29 PM     CPU     %user     %nice   %system   %iowait    %steal     %idle
#	04:09:30 PM     all     24.45      0.00      4.33      0.00      0.00     71.22
#	Average:        all     24.45      0.00      4.33      0.00      0.00     71.22
#
while true
do
	# Output will be like one line per second :
	# %cpu-user %cpu-nice %cpu-system %cpu-iowait %cpu-steal memory-used-MB timestamp
	echo "$(sar 1 1 | grep Average|awk '{print $3" "$4" "$5" "$6" "$7}') $(free -m|grep Mem:|awk '{print $3}') $(date "+%s")" >> /data/metrics.log
done
