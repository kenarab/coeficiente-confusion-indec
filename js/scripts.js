
const CSV_URL  = 'data/ipc_2005_2014_coeficiente_confusion.csv'
d3.csv(CSV_URL, function(err, data){
	"use strict";
	data = add_timestamp_to_data(data);
	
	var data_chart = map_for_chart(data);
	
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

});



// helpers

function add_timestamp_to_data(data){

    data = data.map(function(d){ 
        var date = d.periodo.split("-");
        d.timestamp = new Date(date[0], date[1]).getTime();
        return d;
    });

    return data;
}

function map_for_chart (data) {
	// var keys = ["IPC.INDEC", "IPC.San.Luis"]
	
	var columns = [
		['x'],
		["IPC.INDEC"],
		["IPC.San.Luis"]
	];
	
	data.forEach(function(d){
		// console.log()
		columns[0].push(d['periodo']);
		columns[1].push(d['IPC.INDEC']);
		columns[2].push(d['IPC.San.Luis']);
		// temp_data_chart.push(t);
	});
	console.log(columns)

	// temp_data_chart.push(time)

	return {
		x: 'x',
		xFormat: '%Y-%m-%d',
		// xs: xs,
		//        xFormat: '%Y%m%d', // 'xFormat' can be used as custom format of 'x'
		columns: columns
	};
}

