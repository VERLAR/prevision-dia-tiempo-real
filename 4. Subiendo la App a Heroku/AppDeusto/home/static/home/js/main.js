function graph_minute(array) {
    Highcharts.chart('ticket-minuto-grafico', {
        chart: {
            zoomType: 'x',
            backgroundColor: 'rgba(0,0,0,0)'
        },
        exporting: {
            enabled: false
        },
        credits: {
            enabled: false
        },
        title: {
            text: 'Ventas por minuto',
            style: {
                'color': 'white'
            }
        },
        xAxis: {
            type: 'datetime',
            labels: {
                style: {
                    'color': 'white'
                }
            }
        },
        yAxis: {
            title: '',
            labels: {
                style: {
                    'color': 'white'
                }
            },
            min: 0
        },
        tooltip: {
            valueDecimals: 2,
            valueSuffix: ' €'
        },
        legend: {
            enabled: false
        },
        plotOptions: {
            area: {
                fillColor: {
                    linearGradient: {
                        x1: 0,
                        y1: 0,
                        x2: 0,
                        y2: 1
                    },
                    stops: [[0, Highcharts.getOptions().colors[0]], [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]]
                },
                marker: {
                    radius: 2
                },
                lineWidth: 1,
                states: {
                    hover: {
                        lineWidth: 1
                    }
                },
                threshold: null
            }
        },
        series: [{
            type: 'area',
            name: 'Ventas minuto',
            data: array,
            animation: {
                duration: 4000
            }
        }],
    });
}


function graph_cumulate(real_array, text, prediction_array) {
    Highcharts.chart('prevision-actual-grafico', {
        chart: {
            zoomType: 'x',
            backgroundColor: 'rgba(0,0,0,0)'
        },
        exporting: {
            enabled: false
        },
        credits: {
            enabled: false
        },
        title: {
            text: 'Previsión Actual',
            style: {
                'color': 'white'
            },
            margin: -10
        },
        subtitle: {
            text: text.toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, " ") + ' €',
            useHTML: true,
            style: {
                padding: '5px',
                borderRadius: '4px',
                color: 'white'
            }
        },
        xAxis: {
            type: 'datetime',
            labels: {
                style: {
                    'color': 'white'
                }
            }
        },
        yAxis: {
            title: '',
            labels: {
                style: {
                    'color': 'white'
                }
            },
            endOnTick: false,
            min: 0
        },
        tooltip: {
            valueDecimals: 2,
            valueSuffix: ' €',
            shared: true
        },
        legend: {
            enabled: false
        },
        plotOptions: {
            line: {
                color: '#f28f43',
                marker: {
                    radius: 2
                },
                lineWidth: 1,
                states: {
                    hover: {
                        lineWidth: 1
                    }
                },
                threshold: null
            }
        },
        series: [{
            type: 'line',
            name: 'Ventas acumuladas',
            data: real_array,
            animation: {
                duration: 4000
            }
        },
        {
            type: 'line',
            name: 'Predicción',
            data: prediction_array,
            animation: {
                duration: 4000
            },
            dashStyle: 'Dash'
        }
        ],
    });
}