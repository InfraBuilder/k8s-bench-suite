# k8s-bench-suite
Bash scripts collection to benchmark kubernetes cluster performance

## [knb](knb) : Kubernetes Network Benchmark

### Quickstart

Choose two nodes to act as server/client on your cluster (for example node1 and node2) . Then start the knb : 

```bash
./knb --verbose -client-node node1 -server-node node2
```

After a while, you should see similar output :

```
aducastel@infrabuilder:~/k8s-bench-suite$ ./knb -v -cn node1 -sn node2
2020-08-21 18:08:47 [INFO] Client node will be 'node1'
2020-08-21 18:08:47 [INFO] Server node will be 'node2'
2020-08-21 18:08:47 [INFO] Deploying iperf server on node node2
2020-08-21 18:08:49 [INFO] Waiting for server to be running
2020-08-21 18:08:51 [INFO] Starting TCP P2P client benchmark on node node1
2020-08-21 18:08:52 [INFO] Waiting for TCP P2P benchmark to be completed
2020-08-21 18:09:06 [INFO] TCP P2P bandwidth : 4957
2020-08-21 18:09:06 [INFO] Starting UDPP2P client benchmark on node node1
2020-08-21 18:09:07 [INFO] Waiting for UDP P2P benchmark to be completed
2020-08-21 18:09:20 [INFO] UDP P2P bandwidth : 4846
2020-08-21 18:09:20 [INFO] Starting TCP client benchmark on node node1
2020-08-21 18:09:21 [INFO] Waiting for TCP P2S benchmark to be completed
2020-08-21 18:09:35 [INFO] TCP P2S bandwidth :
2020-08-21 18:09:35 [INFO] Starting UDP P2S client benchmark on node node1
2020-08-21 18:09:36 [INFO] Waiting for UDP P2S benchmark to be completed
2020-08-21 18:09:50 [INFO] UDP P2S bandwidth : 4943
=========================================================
 Results
=========================================================
  Pod to pod :
    TCP :
      bandwidth = 4957 Mbit/s
    UDP :
      bandwidth = 4846 Mbit/s
  Pod to Service :
    TCP :
      bandwidth = 4901 Mbit/s
    UDP :
      bandwidth = 4943 Mbit/s
=========================================================
2020-08-21 18:09:50 [INFO] Cleaning kubernetes resources ...
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

