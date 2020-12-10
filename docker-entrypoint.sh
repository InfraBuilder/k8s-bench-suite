#!/bin/bash -x

# This is a helper script which pre-selects a few worker nodes and
# provides them to knb as --client/server-node arguments if
# NODE_AUTOSELECT variable is set
#
# In order to choose from manager nodes as well, MASTER_ELIGABLE
# variable should be also set.

node_args=
master_eligable="!"

if [[ -n $NODE_AUTOSELECT ]]
then
  if [[ -n $MASTER_ELIGABLE ]]
  then
    master_eligable=
  fi
  worker_nodes=$(kubectl get nodes -l "$master_eligable node-role.kubernetes.io/master" -o name|awk -F '/' '{print $2}')
  if [[ -z $worker_nodes ]]
  then
    echo "No available nodes found for scheduling"
    exit 1
  fi
  test_nodes=($worker_nodes)
  node_args="--client-node ${test_nodes[0]} --server-node ${test_nodes[1]}"
fi

knb $node_args "$@"
