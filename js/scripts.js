// https://docs.google.com/document/d/1nW5JdLrGwxEvFUgXh5qc6II9Z1Dvg7OBqZ0mHz04Ph4/edit#
const CSV_URL  = 'data/ipc_2005_2014_coeficiente_confusion.csv',
	CHART_1 = ["IPC.San.Luis", "IPC.INDEC" ],
	CHART_2 = ["IPC.San.Luis.acumulado.anual", "IPC.INDEC.acumulado.anual"],
	CHART_3 = ["coeficiente.confusion", "coeficiente.confusion.acumulado.anual"],
	CHART_4 = ["IPC.San.Luis", "IPC.INDEC", 'IPC.San.Luis.acumulado.anual', 'IPC.INDEC.acumulado.anual'],
	AXES_Y2_CHART_4 = {
	        "IPC.INDEC.acumulado.anual": 'y2', // ADD
	        "IPC.San.Luis.acumulado.anual": 'y2' // ADD
	      };


var g_data;

function drag_chart(arr_keys, axes_y2, chart_type){

	var data_chart = map_for_chart(g_data, arr_keys);
	
	data_chart.names = {
		"IPC.San.Luis": "San Luis", 
		"IPC.INDEC": "INDEC",
		"IPC.San.Luis.acumulado.anual": "Acum Anual San Luis",
		"IPC.INDEC.acumulado.anual": "Acum. Anual INDEC",
		"coeficiente.confusion": "CC acumulada",
		"coeficiente.confusion.acumulado.anual": "CC acumulada anual"
	}

	if(chart_type){
		data_chart.type = chart_type;
	}
	
	var axis = {
            x: {
                type: 'timeseries',
                tick: {
                    format: '%Y-%m-%d'
                }
            }
        };


	if (axes_y2){
		
		data_chart.axes = axes_y2;

		axis.y2 = {
            	show: true
            }
	
	}	
	
	var chart = c3.generate({
        bindto: '#chart',
        data: data_chart,
        axis: axis,
        color: {
        	pattern: ['blue', 'green', ]
    	},
    	point: {
    		show: true,
    		r: 0,
    		focus: {
				expand: {
				  enabled: true,
				  r: 4
				}
			}
    	},
        grid: {
		  x: {
		  	show: true,
		    lines: [
		      {value: "2006-12-01", text: 'comienzo intervención', class: "red"}
		    ]
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

function add_timestamp_to_data(data){

    data = data.map(function(d){ 
        var date = d.periodo.split("-");
        d.timestamp = new Date(date[0], date[1]).getTime();
        return d;
    });

    return data;
}
