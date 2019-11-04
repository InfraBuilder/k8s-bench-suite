#!/bin/bash

function pod_wait_for_status {
	while true
	do
		STATUS=$(kubectl get pod $1 2>/dev/null|tail -n 1| awk '{print $3}')
		debug 2 "Pod $1 is in state $STATUS (waiting for $2)"
		[ "$STATUS" = "$2" ] && break
		sleep 1
	done
}

function debug {
	[ "$DEBUG" -ge "$1" ] && echo "${@:2}" >/dev/null
}

STORAGECLASS=$1
SIZE=${SIZE:-5Gi}
DEBUG=${DEBUG:-0}


debug 1 "Creating PVC"
kubectl apply -f - >/dev/null <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: bench-$$-$STORAGECLASS
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: $SIZE
  storageClassName: $STORAGECLASS
EOF

debug 1 "Starting Benchmark"
kubectl apply -f - >/dev/null <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: bench-$$-$STORAGECLASS
spec:
  containers:
   - name: bench
     image: infrabuilder/iobench
     stdin: true
     tty: true
     volumeMounts:
       - name: mypvc
         mountPath: /root
  volumes:
   - name: mypvc
     persistentVolumeClaim:
       claimName: bench-$$-$STORAGECLASS
       readOnly: false
EOF
pod_wait_for_status bench-$$-$STORAGECLASS Running

#================================================
#   ___  ___
#  |_ _|/ _ \
#   | || | | |
#   | || |_| |
#  |___|\___/
#
#================================================

DBENCH_MOUNTPOINT=/root
FIO_SIZE=2G
FIO_OFFSET_INCREMENT=500M
FIO_DIRECT=1
echo Working dir: $DBENCH_MOUNTPOINT
echo
echo Testing Read IOPS...
READ_IOPS=$(kubectl exec -it bench-$$-$STORAGECLASS -- fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --gtod_reduce=1 --name=read_iops --filename=$DBENCH_MOUNTPOINT/fiotest --bs=4K --iodepth=64 --size=$FIO_SIZE --readwrite=randread --time_based --ramp_time=2s --runtime=15s)
echo "$READ_IOPS"
READ_IOPS_VAL=$(echo "$READ_IOPS"|grep -E 'read ?:'|grep -Eoi 'IOPS=[0-9k.]+'|cut -d'=' -f2)
echo
echo
echo Testing Write IOPS...
WRITE_IOPS=$(kubectl exec -it bench-$$-$STORAGECLASS -- fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --gtod_reduce=1 --name=write_iops --filename=$DBENCH_MOUNTPOINT/fiotest --bs=4K --iodepth=64 --size=$FIO_SIZE --readwrite=randwrite --time_based --ramp_time=2s --runtime=15s)
echo "$WRITE_IOPS"
WRITE_IOPS_VAL=$(echo "$WRITE_IOPS"|grep -E 'write:'|grep -Eoi 'IOPS=[0-9k.]+'|cut -d'=' -f2)
echo
echo
echo Testing Read Bandwidth...
READ_BW=$(kubectl exec -it bench-$$-$STORAGECLASS -- fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --gtod_reduce=1 --name=read_bw --filename=$DBENCH_MOUNTPOINT/fiotest --bs=128K --iodepth=64 --size=$FIO_SIZE --readwrite=randread --time_based --ramp_time=2s --runtime=15s)
echo "$READ_BW"
READ_BW_VAL=$(echo "$READ_BW"|grep -E 'read ?:'|grep -Eoi 'BW=[0-9GMKiBs/.]+'|cut -d'=' -f2)
echo
echo
echo Testing Write Bandwidth...
WRITE_BW=$(kubectl exec -it bench-$$-$STORAGECLASS -- fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --gtod_reduce=1 --name=write_bw --filename=$DBENCH_MOUNTPOINT/fiotest --bs=128K --iodepth=64 --size=$FIO_SIZE --readwrite=randwrite --time_based --ramp_time=2s --runtime=15s)
echo "$WRITE_BW"
WRITE_BW_VAL=$(echo "$WRITE_BW"|grep -E 'write:'|grep -Eoi 'BW=[0-9GMKiBs/.]+'|cut -d'=' -f2)
echo
echo
echo Testing Read Latency...
READ_LATENCY=$(kubectl exec -it bench-$$-$STORAGECLASS -- fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --name=read_latency --filename=$DBENCH_MOUNTPOINT/fiotest --bs=4K --iodepth=4 --size=$FIO_SIZE --readwrite=randread --time_based --ramp_time=2s --runtime=15s)
echo "$READ_LATENCY"
READ_LATENCY_VAL=$(echo "$READ_LATENCY"|grep ' lat.*avg'|grep -Eoi 'avg=[0-9.]+'|cut -d'=' -f2)
echo
echo
echo Testing Write Latency...
WRITE_LATENCY=$(kubectl exec -it bench-$$-$STORAGECLASS -- fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --name=write_latency --filename=$DBENCH_MOUNTPOINT/fiotest --bs=4K --iodepth=4 --size=$FIO_SIZE --readwrite=randwrite --time_based --ramp_time=2s --runtime=15s)
echo "$WRITE_LATENCY"
WRITE_LATENCY_VAL=$(echo "$WRITE_LATENCY"|grep ' lat.*avg'|grep -Eoi 'avg=[0-9.]+'|cut -d'=' -f2)
echo
echo
echo Testing Read Sequential Speed...
READ_SEQ=$(kubectl exec -it bench-$$-$STORAGECLASS -- fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --gtod_reduce=1 --name=read_seq --filename=$DBENCH_MOUNTPOINT/fiotest --bs=1M --iodepth=16 --size=$FIO_SIZE --readwrite=read --time_based --ramp_time=2s --runtime=15s --thread --numjobs=4 --offset_increment=$FIO_OFFSET_INCREMENT)
echo "$READ_SEQ"
READ_SEQ_VAL=$(echo "$READ_SEQ"|grep -E 'READ:'|grep -Eoi '(aggrb|bw)=[0-9GMKiBs/.]+'|cut -d'=' -f2)
echo
echo
echo Testing Write Sequential Speed...
WRITE_SEQ=$(kubectl exec -it bench-$$-$STORAGECLASS -- fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --gtod_reduce=1 --name=write_seq --filename=$DBENCH_MOUNTPOINT/fiotest --bs=1M --iodepth=16 --size=$FIO_SIZE --readwrite=write --time_based --ramp_time=2s --runtime=15s --thread --numjobs=4 --offset_increment=$FIO_OFFSET_INCREMENT)
echo "$WRITE_SEQ"
WRITE_SEQ_VAL=$(echo "$WRITE_SEQ"|grep -E 'WRITE:'|grep -Eoi '(aggrb|bw)=[0-9GMKiBs/.]+'|cut -d'=' -f2)
echo
echo
echo Testing Read/Write Mixed...
RW_MIX=$(kubectl exec -it bench-$$-$STORAGECLASS -- fio --randrepeat=0 --verify=0 --ioengine=libaio --direct=$FIO_DIRECT --gtod_reduce=1 --name=rw_mix --filename=$DBENCH_MOUNTPOINT/fiotest --bs=4k --iodepth=64 --size=$FIO_SIZE --readwrite=randrw --rwmixread=75 --time_based --ramp_time=2s --runtime=15s)
echo "$RW_MIX"
RW_MIX_R_IOPS=$(echo "$RW_MIX"|grep -E 'read ?:'|grep -Eoi 'IOPS=[0-9k.]+'|cut -d'=' -f2)
RW_MIX_W_IOPS=$(echo "$RW_MIX"|grep -E 'write:'|grep -Eoi 'IOPS=[0-9k.]+'|cut -d'=' -f2)
echo
echo
echo All tests complete.
echo
echo ==================
echo = Dbench Summary =
echo ==================
echo "Random Read/Write IOPS: $READ_IOPS_VAL/$WRITE_IOPS_VAL. BW: $READ_BW_VAL/ $WRITE_BW_VAL"
echo "Average Latency (usec) Read/Write: $READ_LATENCY_VAL/$WRITE_LATENCY_VAL"
echo "Sequential Read/Write: $READ_SEQ_VAL / $WRITE_SEQ_VAL"
echo "Mixed Random Read/Write IOPS: $RW_MIX_R_IOPS/$RW_MIX_W_IOPS"

#================================================
#   _____   __                    _
#  / ___/  / / ___  ___ _  ___   (_)  ___   ___ _
# / /__   / / / -_)/ _ `/ / _ \ / /  / _ \ / _ `/
# \___/  /_/  \__/ \_,_/ /_//_//_/  /_//_/ \_, /
#                                         /___/
#================================================

debug 1 "Deleting pod"
kubectl delete pod/bench-$$-$STORAGECLASS >/dev/null

debug 1 "Deleting pvc"
kubectl delete pvc/bench-$$-$STORAGECLASS > /dev/null



