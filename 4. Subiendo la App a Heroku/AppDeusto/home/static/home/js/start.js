function draw(){

    $.when($.getJSON('/redis_data/ventas_minuto'),
           $.getJSON('/redis_data/ventas_acumuladas_minuto'),
           $.getJSON('/redis_data/prediccion'),
           $.getJSON('/redis_data/prediccion_minuto')).then(function (minuto, acumulado, prediccion, prediccion_minuto) {
               graph_minute(minuto[0]);
               graph_cumulate(acumulado[0], prediccion[0], prediccion_minuto[0]);
    }).fail(function (problem) {
        console.log(problem);
    });
}

draw();
setInterval(draw, 20 * 1000);
