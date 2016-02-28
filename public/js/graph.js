'use strict';

var insertGraph = function () {
    d3.json('data/fake.json', function(data) {
        for (var i = 0; i < data.length; i++) {
            data[i] = MG.convert.date(data[i], 'date');
        }

        data[1][data[1].length-1].value = 50000000;
        data[2][data[2].length-1] = MG.clone(data[1][data[1].length-1]);
        data[2][data[2].length-1].value += 10000000;

        MG.data_graphic({
            title: "Labeling Lines",
            data: data,
            width: 600,
            height: 200,
            animate_on_load: true,
            transition_on_update: true,
            legend: ['US', 'CA', 'DE'],
            target: '.graph-container'
        });
    });
};

insertGraph();

