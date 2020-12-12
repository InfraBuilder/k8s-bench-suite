{
    "data": [
        {
            "meta": {
                "columnNames": {
                    "x": "scenario",
                    "y": "throughput"
                }
            },
            "name": "throughput",
            "type": "bar",
            "x": [
                if .data.pod2pod.tcp? then "pod2pod-tcp" else empty end,
                if .data.pod2pod.udp? then "pod2pod-udp" else empty end,
                if .data.pod2svc.tcp? then "pod2svc-tcp" else empty end,
                if .data.pod2svc.udp? then "pod2svc-udp" else empty end
            ],
            "y": [
                if .data.pod2pod.tcp? then .data.pod2pod.tcp.bandwidth else empty end,
                if .data.pod2pod.udp? then .data.pod2pod.udp.bandwidth else empty end,
                if .data.pod2svc.tcp? then .data.pod2svc.tcp.bandwidth else empty end,
                if .data.pod2svc.udp? then .data.pod2svc.udp.bandwidth else empty end
            ],
            "marker": {
                "line": {},
                "color": "rgb(49, 61, 172)"
            },
            "text": [
                if .data.pod2pod.tcp? then .data.pod2pod.tcp.bandwidth else empty end,
                if .data.pod2pod.udp? then .data.pod2pod.udp.bandwidth else empty end,
                if .data.pod2svc.tcp? then .data.pod2svc.tcp.bandwidth else empty end,
                if .data.pod2svc.udp? then .data.pod2svc.udp.bandwidth else empty end
            ],
            "showlegend": true,
            "legendgroup": 1,
            "textposition": "inside"
        }
    ],
    "layout": {
        "font": {
            "size": 12,
            "color": "rgb(33, 33, 33)",
            "family": "\"Droid Serif\", serif"
        },
        "title": {
            "text": "K8S internal network bandwidth, Mbit/s"
        },
        "xaxis": {
            "tickfont": {
                "size": 14,
                "family": "Droid Serif"
            },
            "tickangle": -45
        },
        "yaxis": {
            "tickfont": {
                "size": 14,
                "family": "Droid Serif"
            }
        }
    }
}
