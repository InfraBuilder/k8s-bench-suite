Custom benchmark monitor for https://github.com/InfraBuilder/k8s-bench-suite

default command starts the /monit.sh script that will output a new line in `/data/metrics.log` each second with following information :
```sh
%cpu-user %cpu-nice %cpu-system %cpu-iowait %cpu-steal memory-used-MB timestamp
```

You can query a subset of data between two timestamp with the /stats.sh script :
```sh
sh /script.sh 1598047515 1598047530
```