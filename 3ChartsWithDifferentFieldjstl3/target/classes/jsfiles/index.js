/**
 * 
 */
var myApp = angular.module('myApp', ['chart.js']);

// Create the controller, the 'ToddlerCtrl' parameter 
// must match an ng-controller directive
myApp.controller('ChartCtrl', function ($scope) {
   var chart_div = $('#chartDiv');
   chart_div.empty();
   canvas_html = '<canvas id="chart-2" class="chart chart-doughnut" chart-data="chart.data" chart-labels="chart.labels"></canvas>';
   console.log(canvas_html)
   chart_div.append(canvas_html);
   //console.log(chart_div)
  $scope.chart =    {
     name: 'Chart 1',
     type: 'Doughnut',
     labels: ['EVSC', 'ISB'],
     data: [13, 44]
   };
});