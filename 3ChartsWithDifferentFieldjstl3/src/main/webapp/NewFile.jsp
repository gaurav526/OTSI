<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

  <script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/1.0.2/Chart.min.js"></script>
    <script data-require="angular.js@1.2.7" data-semver="1.2.7" src="http://code.angularjs.org/1.2.7/angular.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/angular-chart.js/0.8.3/angular-chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/angular-chart.js/0.8.3/angular-chart.css" />
    <link rel="stylesheet" href="style.css" />
    <script src="script.js"></script>
</head>
<body>
 <div ng-controller="ChartCtrl">
      <div>
        {{chart.name}}
        This works (doughnut):
        <canvas id="chart-{{$index}}" class="chart chart-doughnut" chart-data="chart.data" chart-labels="chart.labels"></canvas>
      </div>
      This Doesn't work ({{chart.type}}):
      <div id="chartDiv"> </div>
    </div>
</body>
</html>