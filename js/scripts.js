
const CSV_URL  = 'data/ipc_2005_2014_coeficiente_confusion.csv',
	CHART_1 = ["IPC.INDEC", "IPC.San.Luis"],
	CHART_2 = ['IPC.INDEC.acumulado.anual', 'IPC.San.Luis.acumulado.anual'],
	CHART_3 = ["coeficiente.confusion", "coeficiente.confusion.acumulado.anual"];
var g_data;

d3.csv(CSV_URL, function(err, data){
	"use strict";
	g_data = add_timestamp_to_data(data);
	
	drag_chart(CHART_1)
});

function drag_chart(arr_keys){

	var data_chart = map_for_chart(g_data, arr_keys);
	
	var chart = c3.generate({
        bindto: '#chart',
        data: data_chart,
        axis: {
            x: {
                type: 'timeseries',
                tick: {
                    format: '%Y-%m-%d'
                }
            }
        },
        subchart: {
            show: true
        },
        zoom: {
            enabled: true
        }
    });
}


// helpers

function add_timestamp_to_data(data){

    data = data.map(function(d){ 
        var date = d.periodo.split("-");
        d.timestamp = new Date(date[0], date[1]).getTime();
        return d;
    });

    return data;
}

function map_for_chart (data, arr_keys) {
	var columns = [
		['x']
	];
	
	for (i in arr_keys){ // tomo las columnas pedidas
		columns.push([arr_keys[i]]);
	}
	data.forEach(function(d){
		columns[0].push(d['periodo']);
		for (i in arr_keys){ // tomo las columnas pedidas
			columns[+i+1].push(d[arr_keys[i]]);
		}
	});


	return {
		x: 'x',
		xFormat: '%Y-%m-%d',
		// xs: xs,
		//        xFormat: '%Y%m%d', // 'xFormat' can be used as custom format of 'x'
		columns: columns
	};
}

