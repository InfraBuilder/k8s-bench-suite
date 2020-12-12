#!/bin/bash -x

# NODE_AUTOSELECT=1 pre-selects a few worker nodes and
# provides them to knb as --client/server-node arguments
#
# MASTER_ELIGIBLE=1 choose from manager nodes as well
#

node_args=
master_eligible="!"

if [[ -n $NODE_AUTOSELECT ]]
then
  if [[ -n $MASTER_ELIGIBLE ]]
  then
    master_eligible=
  fi
  worker_nodes=$(kubectl get nodes -l "$master_eligible node-role.kubernetes.io/master" -o name|awk -F '/' '{print $2}')
  if [[ -z $worker_nodes ]]
  then
    echo "No available nodes found for scheduling"
    exit 1
  fi
  test_nodes=($worker_nodes)
  node_args="--client-node ${test_nodes[0]} --server-node ${test_nodes[1]}"
fi

knb "$@" $node_args
