'use strict';

var insertGraph = function () {
    d3.json('data/fake.json', function(data) {
        for (var i = 0; i < data.length; i++) {
            data[i] = MG.convert.date(data[i], 'date');
        }
        MG.data_graphic({
            title: "Labeling Lines",
            data: data,
            height: 200,
            width: 600,
            animate_on_load: true,
            missing_is_hidden: true,
            brushing: true,
            brushing_history: true,
            transition_on_update: true,
            legend: ['US', 'CA', 'DE'],
            target: '.graph-container'
        });
    });
};

insertGraph();

