'use strict';

var insertGraph = function () {
    d3.json('data/fake.json', function(data) {
        var format = d3.time.format("%a %b %e %H:%M:%S %Z %Y");
        for (var i = 0; i < data.length; i++) {
            data[i] = MG.convert.date(data[i], 'date', "%a %b %e %H:%M:%S %Z %Y");
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
            legend: ['Sanders', 'Clinton', 'Trump', 'Rubio', 'Cruz', 'Kasich', 'Carson'],
            show_rollover_text: false,
            target: '.graph-container',


            mouseover: function(d, i) {
            var numCandidates = 7;
                for (var j = 1; j <= numCandidates; j++) {
                    var id ="c"+j;
                    var domElement = document.getElementsByClassName(id)[0];
                    document.getElementsByClassName(id)[0].style.visibility = "visible";

                    console.log(domElement.innerHTML);
                    domElement.innerHTML = d.values[j-1].value.toFixed(2);


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