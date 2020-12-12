{
    "data": [
        {
            "meta": {
                "columnNames": {
                    "x": "scenario",
                    "y": "client",
                    "text": "client"
                }
            },
            "name": "client",
            "type": "bar",
            "x": [
                if .data.idle? then "Idle" else empty end,
                if .data.pod2pod.tcp? then "pod2pod-tcp" else empty end,
                if .data.pod2pod.udp? then "pod2pod-udp" else empty end,
                if .data.pod2svc.tcp? then "pod2svc-tcp" else empty end,
                if .data.pod2svc.udp? then "pod2svc-udp" else empty end
            ],
            "y": [
                if .data.idle? then .data.idle.client.ram else empty end,
                if .data.pod2pod.tcp? then .data.pod2pod.tcp.client.ram else empty end,
                if .data.pod2pod.udp? then .data.pod2pod.udp.client.ram else empty end,
                if .data.pod2svc.tcp? then .data.pod2svc.tcp.client.ram else empty end,
                if .data.pod2svc.udp? then .data.pod2svc.udp.client.ram else empty end
            ],
            "marker": {
                "color": "rgb(147, 75, 232)"
            },
            "text": [
                if .data.idle? then .data.idle.client.ram else empty end,
                if .data.pod2pod.tcp? then .data.pod2pod.tcp.client.ram else empty end,
                if .data.pod2pod.udp? then .data.pod2pod.udp.client.ram else empty end,
                if .data.pod2svc.tcp? then .data.pod2svc.tcp.client.ram else empty end,
                if .data.pod2svc.udp? then .data.pod2svc.udp.client.ram else empty end
            ],
            "showlegend": true,
            "legendgroup": 1,
            "textposition": "inside"
        },
        {
            "meta": {
                "columnNames": {
                    "x": "scenario",
                    "y": "server",
                    "text": "server",
                    "marker": {
                        "color": "server"
                    }
                }
            },
            "name": "server",
            "type": "bar",
            "x": [
                if .data.idle? then "Idle" else empty end,
                if .data.pod2pod.tcp? then "pod2pod-tcp" else empty end,
                if .data.pod2pod.udp? then "pod2pod-udp" else empty end,
                if .data.pod2svc.tcp? then "pod2svc-tcp" else empty end,
                if .data.pod2svc.udp? then "pod2svc-udp" else empty end
            ],
            "y": [
                if .data.idle? then .data.idle.server.ram else empty end,
                if .data.pod2pod.tcp? then .data.pod2pod.tcp.server.ram else empty end,
                if .data.pod2pod.udp? then .data.pod2pod.udp.server.ram else empty end,
                if .data.pod2svc.tcp? then .data.pod2svc.tcp.server.ram else empty end,
                if .data.pod2svc.udp? then .data.pod2svc.udp.server.ram else empty end
            ],
            "yaxis": "y",
            "marker": {
                "meta": {
                    "columnNames": {
                        "color": "server"
                    }
                },
                "color": "rgb(252, 1, 149)"
            },
            "text": [
                if .data.idle? then .data.idle.server.ram else empty end,
                if .data.pod2pod.tcp? then .data.pod2pod.tcp.server.ram else empty end,
                if .data.pod2pod.udp? then .data.pod2pod.udp.server.ram else empty end,
                if .data.pod2svc.tcp? then .data.pod2svc.tcp.server.ram else empty end,
                if .data.pod2svc.udp? then .data.pod2svc.udp.server.ram else empty end
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
            "text": "RAM usage, MB"
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
        },
        "barmode": "group",
        "boxmode": "overlay",
        "modebar": {
            "orientation": "h"
        }
    }
}
