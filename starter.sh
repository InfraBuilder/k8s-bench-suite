#!/bin/bash

# This is a helper script which pre-selects a few worker nodes and
# provides them to knb as --client/server-node arguments

worker_nodes=$(kubectl get nodes -l '! node-role.kubernetes.io/master' -o name|awk -F '/' '{print $2}')
test_nodes=($worker_nodes)

knb --client-node ${test_nodes[0]} --server-node ${test_nodes[1]} "$@"
