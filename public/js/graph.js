'use strict';

var insertGraph = function () {
    d3.json('data/fake.json', function(data) {
        for (var i = 0; i < data.length; i++) {
            data[i] = MG.convert.date(data[i], 'date');
        }
        MG.data_graphic({
            title: "How Twitter Feels About The Election",
            data: data,
            full_width : true,
            height: 200,
            full_width: true,
            animate_on_load: true,
            missing_is_hidden: true,
            brushing: true,
            brushing_history: true,
            transition_on_update: true,
            legend: ['US', 'CA', 'DE'],
            target: '.graph-container',
            
        });
    });
};

insertGraph();

/*
    TODO for candidates
    legend: ['Bernie Sanders', 'Hillary Clinton', 'Donald Trump', 'Marco Rubio', 'Ted Cruz', 'John Kasich', 'Ben Carson']
*/