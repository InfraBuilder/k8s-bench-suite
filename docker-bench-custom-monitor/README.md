Custom benchmark monitor for https://github.com/InfraBuilder/k8s-bench-suite

![Docker Image Size (tag)](https://img.shields.io/docker/image-size/infrabuilder/bench-custom-monitor/latest) [Dockerfile](https://github.com/InfraBuilder/k8s-bench-suite/blob/master/docker-bench-custom-monitor/Dockerfile)

## How does it work

Default CMD starts the /[monit.sh](monit.sh) script that will monitor the host using tools like **sar** and **free** , outputing a new line in `/data/metrics.log` each second with following information :

```sh
%cpu-user %cpu-nice %cpu-system %cpu-iowait %cpu-steal memory-used-MB timestamp
```

Data produced per second : **40 bytes/s**

## Get metrics

You can query a subset of data between two timestamp with the /[stats.sh](stats.sh) script :

```sh
sh /script.sh 1598047515 1598047530
```
