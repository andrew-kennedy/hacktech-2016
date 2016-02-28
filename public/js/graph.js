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
            animate_on_load: true,
            missing_is_hidden: true,
            brushing: true,
            brushing_history: true,
            transition_on_update: true,
            legend: ['US', 'CA', 'DE'],
            target: '.graph-container',
            
            
            mouseover: function(d, i) {
                
            var numCandidates = 3; //7;
                for (var j = 1; j <= numCandidates; j++) {
                    var id ="c"+j;
                    document.getElementsByClassName(id)[0].innerHTML = d.values[j-1].value;
                }
            }
            
        });
    });
};

insertGraph();

/*
    TODO for candidates
    legend: ['Bernie Sanders', 'Hillary Clinton', 'Donald Trump', 'Marco Rubio', 'Ted Cruz', 'John Kasich', 'Ben Carson']
*/