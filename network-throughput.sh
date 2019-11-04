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

BENCH_TIME=${BENCH_TIME:-10}
DEBUG=${DEBUG:-0}

# Topology values can be :
# - kubernetes.io/hostname
# - failure-domain.beta.kubernetes.io/zone
# - failure-domain.beta.kubernetes.io/region
TOPOLOGY=${TOPOLOGY:-kubernetes.io/hostname}


debug 1 "Starting iperf server"
kubectl apply -f - >/dev/null <<EOF
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: infrabuilder-iperf-server
    benchmark: network
  name: infrabuilder-iperf-server
spec:
  containers:
  - args:
    - iperf3
    - -s
    image: infrabuilder/netbench:server-iperf3
    name: iperf
  restartPolicy: Never
EOF

pod_wait_for_status infrabuilder-iperf-server Running

IP=$(kubectl get pod infrabuilder-iperf-server -o wide | tail -n 1| awk '{print $6}')
NODESRV=$(kubectl get pod infrabuilder-iperf-server -o wide | tail -n 1| awk '{print $7}')


#================================================
#  ______  _____   ___
# /_  __/ / ___/  / _ \
#  / /   / /__   / ___/
# /_/    \___/  /_/
#
#================================================
kubectl apply -f - >/dev/null <<EOF
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: infrabuilder-iperf-tcp
    benchmark: network
  name: infrabuilder-iperf-tcp
spec:
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - topologyKey: $TOPOLOGY
        labelSelector:
          matchExpressions:
          - key: run
            operator: In
            values:
            - infrabuilder-iperf-server
  containers:
  - args:
    - /bin/sh
    - -c
    - iperf3 -c $IP -O 1 -f m -t $BENCH_TIME
    image: infrabuilder/netbench:client
    name: iperf
  restartPolicy: Never
EOF

debug 1 "Waiting for iperf3 client to finish"
pod_wait_for_status infrabuilder-iperf-tcp Completed

#kubectl wait --for=condition=Completed pod/infrabuilder-iperf-tcp --timeout=$(( $BENCH_TIME + 30 ))s
NODECLIENT=$(kubectl get pod infrabuilder-iperf-tcp -o wide | tail -n 1| awk '{print $7}')

debug 1 "Benchmark ran from $NODECLIENT to $NODESRV"

debug 1 "Getting results"
#TCP_RESULT=$(kubectl logs infrabuilder-iperf-tcp| grep receiver| awk '{print $7}')
kubectl logs infrabuilder-iperf-tcp

#================================================
#   _____   __                    _
#  / ___/  / / ___  ___ _  ___   (_)  ___   ___ _
# / /__   / / / -_)/ _ `/ / _ \ / /  / _ \ / _ `/
# \___/  /_/  \__/ \_,_/ /_//_//_/  /_//_/ \_, /
#                                         /___/
#================================================

debug 1 "Deleting pod iperf server"
kubectl delete pod/infrabuilder-iperf-server >/dev/null

debug 1 "Deleting pod iperf client tcp"
kubectl delete pod/infrabuilder-iperf-tcp > /dev/null

#echo "TCP=$TCP_RESULT"


