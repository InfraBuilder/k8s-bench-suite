# k8s-bench-suite
Bash scripts collection to benchmark kubernetes cluster performance

## [knb](knb) : Kubernetes Network Benchmark

### Requirements

This script needs a valid `kubectl` setup with an access to the target cluster.

Binaries dependencies :

- awk
- grep
- tail
- date
- kubectl

### Quickstart

Choose two nodes to act as server/client on your cluster (for example node1 and node2) . Then start the knb : 

```bash
./knb --verbose -client-node node1 -server-node node2
```

If you omit the `--verbose` flag, it will also complete, but you will have no output until the end of the benchmark.

After a while, you should see similar output :

```
aducastel@infrabuilder:~/k8s-bench-suite$ ./knb -v -cn node1 -sn node2
2020-08-22 00:18:17 [INFO] Client node will be 'node1'
2020-08-22 00:18:17 [INFO] Server node will be 'node2'
2020-08-22 00:18:17 [INFO] Deploying server monitor on node node2
2020-08-22 00:18:18 [INFO] Waiting for server monitor to be running
2020-08-22 00:18:21 [INFO] Deploying client monitor on node node1
2020-08-22 00:18:22 [INFO] Waiting for client monitor to be running
2020-08-22 00:18:25 [INFO] Deploying iperf server on node node2
2020-08-22 00:18:26 [INFO] Waiting for server to be running
2020-08-22 00:18:27 [INFO] Starting pod knb-client-idle-77797 on node node1
2020-08-22 00:18:40 [INFO] Waiting for pod knb-client-idle-77797 to be completed
2020-08-22 00:18:42 [INFO] Starting pod knb-client-tcp-p2p-77797 on node node1
2020-08-22 00:18:54 [INFO] Waiting for pod knb-client-tcp-p2p-77797 to be completed
2020-08-22 00:18:58 [INFO] Starting pod knb-client-udp-p2p-77797 on node node1
2020-08-22 00:19:10 [INFO] Waiting for pod knb-client-udp-p2p-77797 to be completed
2020-08-22 00:19:14 [INFO] Starting pod knb-client-tcp-p2s-77797 on node node1
2020-08-22 00:19:26 [INFO] Waiting for pod knb-client-tcp-p2s-77797 to be completed
2020-08-22 00:19:30 [INFO] Starting pod knb-client-udp-p2s-77797 on node node1
2020-08-22 00:19:43 [INFO] Waiting for pod knb-client-udp-p2s-77797 to be completed
=========================================================
 Results
=========================================================
  Idle :
      bandwidth = 0 Mbit/s
      client cpu = user 2.29%, nice 0.00%, system 0.81%, iowait 0.00%, steal 0.00%
      server cpu = user 0.57%, nice 0.00%, system 0.45%, iowait 0.01%, steal 0.00%
      client ram = 2759 MB
      server ram = 1915 MB
  Pod to pod :
    TCP :
      bandwidth = 4942 Mbit/s
      client cpu = user 0.89%, nice 0.00%, system 2.57%, iowait 0.00%, steal 0.00%
      server cpu = user 0.35%, nice 0.00%, system 1.78%, iowait 0.00%, steal 0.00%
      client ram = 2759 MB
      server ram = 1916 MB
    UDP :
      bandwidth = 4848 Mbit/s
      client cpu = user 0.74%, nice 0.00%, system 6.89%, iowait 1.40%, steal 0.00%
      server cpu = user 0.46%, nice 0.00%, system 2.00%, iowait 0.01%, steal 0.00%
      client ram = 2793 MB
      server ram = 1918 MB
  Pod to Service :
    TCP :
      bandwidth = 4785 Mbit/s
      client cpu = user 1.02%, nice 0.00%, system 2.89%, iowait 0.00%, steal 0.00%
      server cpu = user 0.59%, nice 0.00%, system 2.09%, iowait 0.00%, steal 0.00%
      client ram = 2763 MB
      server ram = 1920 MB
    UDP :
      bandwidth = 4942 Mbit/s
      client cpu = user 0.73%, nice 0.00%, system 7.42%, iowait 0.00%, steal 0.00%
      server cpu = user 0.40%, nice 0.00%, system 2.28%, iowait 0.00%, steal 0.00%
      client ram = 2793 MB
      server ram = 1920 MB
=========================================================
2020-08-22 00:19:47 [INFO] Cleaning kubernetes resources ...
```

### Usage

To display usage, use the `-h` flag :

```bash
aducastel@infrabuilder:~/k8s-bench-suite$ ./knb -h

./knb is a network benchmark tool for Kubernetes CNI

Mandatory flags :
    -cn <nodename>
    --client-node <nodename>    : Define kubernetes node name that will host the client part
    -sn <nodename>
    --server-node <nodename>    : Define kubernetes node name that will host the server part

Optionnal flags :
    --debug                     : Set the debug level to "debug"
    --debug-level <level>       : Set the debug level (values: standard, warn, info, debug)
    -d <time-in-scd>
    --duration <time-in-scd>    : Set the benchmark duration for each test in seconds. (Default 10)
    -h
    --help                      : Display this help message
    -k
    --keep                      : Keep data directory instead of cleaning it (contains raw benchmark data)
    -n <namespace>
    --namespace <namespace>     : Set the target kubernetes namespace
    -o <format>
    --output <format>           : Set the output format (values: text, yaml, json)
    -sbs <size>
    --socket-buffer-size <size> : Set the socket buffer size (Default: 256K)
    -t <time-in-scd>
    --timeout <time-in-scd>     : Set the pod ready wait timeout in seconds. (Default 30)
    -v
    --verbose                   : Activate the verbose mode by setting debug-level to 'info'
    -V
    --version                   : Show current script version

Example : ./knb -v -cn node1 -sn node2
```

### Examples

To run benchmark from node A to node B, showing only result in yaml format :

```bash
./knb -cn A -sn B -o yaml
```

To run benchmark from node Asterix to node Obelix, with the most verbose output and a result as json in a `res.json` file :

```bash
./knb --debug -cn Asterix -sn Obelix -o json > res.json
```

Running benchmark in non context-default namespace :

```bash
./knb -n mynamespace -cn node1 -sn node2
```

