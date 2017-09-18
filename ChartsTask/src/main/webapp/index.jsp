<%@ page isELIgnored="false" language="java"
	contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Index</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.bundle.js" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.bundle.min.js" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.js" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.min.js" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js" />
<script src="path/to/chartjs/dist/Chart.js"></script>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<style type="text/css">
caption {
	background-color: #990000;
	color: #ff0000;
	font-weight: bold;
}

body {
	background-color: #ff8080;
}

table {
	background-color: #ffe6e6;
}
</style>
</head>
<body>
	<jsp:include page="/Charts"></jsp:include>
	<table border=2px align="center">
		<caption>
			<center>
				<h2>Charts</h2>
			</center>
		</caption>

		<!--using froEach of jstl...  -->

		<c:forEach var="all" items="${allids}">
			<tr>
				<td>
					<!--create canvas...  --> <canvas id=${all } width="900"
						height="400"></canvas>
				</td>
			</tr>
		</c:forEach>
	</table>

	<Script type="text/javascript">

  var piechart;
  var barchart;
  var polarchart;
  var doughnutchart;
  var radarchart;
  var linechart;
  
 //function to perform drill on charts...
  function drill(fieldName,clickValue)
  {
	  
	//ajax calling...  
	  $.ajax({
		  	url :"Click",
		  	
		  	type : "POST",
		  	
		  	dataType:"json",
		  	data:{
		  		fieldName:fieldName,
		  		clickValue: clickValue
		  	},
		  	//on success time... 
		  	success : function(dataa){
		  	
		  		for (var index in dataa){
		  			
		  			var labeldata=[];
		  			var labelcounts=[];
		  			data=dataa[index];
		  		

		  		$.each(data.bucketKeys, function(i, item) {
		  			labeldata.push(item);
		  		});
		  		$.each(data.bucketCounts, function(i, item) {
		  			labelcounts.push(item);
		  		});
		  	
		  	
		  		if(data.chart_Type == "bar") {
		  			bar(labeldata,labelcounts,data);	
		  			}
		  		else if (data.chart_Type == "pie") {
		  			pie(labeldata,labelcounts,data);	
		  		}
		  		else if(data.chart_Type == "line") {
		  			line(labeldata,labelcounts,data);
		  		}
		  		else if(data.chart_Type == "polarArea")
		  			{
		  			polar(labeldata,labelcounts,data);
		  			}
		  		else if(data.chart_Type == "doughnut")
		  		{
		  			doughnut(labeldata,labelcounts,data);
		  		}
		  		else if(data.chart_Type == "radar")
		  		{
		  			radar(labeldata,labelcounts,data);
		  		}
		  		
		  		
// function pie...		  		
		  function pie(labeldata,labelcounts,data) {
		  	  var piechartdata= {
		  	    			labels:labeldata,
		  	        datasets: [
		  	            {
		  	            	label:data.field_name,
		  	                data:labelcounts, 
		  	              backgroundColor : [
		  	  				'rgba(255, 99, 132, 0.2)',
		  	  				'rgba(54, 162, 235, 0.2)',
		  	  				'rgba(255, 206, 86, 0.2)',
		  	  				'rgba(75, 192, 192, 0.2)',
		  	  				'rgba(153, 102, 255, 0.2)',
		  	  				'rgba(255, 150, 255, 0.2)',
		  	  				'rgba(255,0,255,0.3)',
		  	  				'rgba(0,255,0,0.3)',
		  	  				'rgba(0,0,255,0.3)' ],
		  	  		borderColor : [
		  	  				'rgba(255,99,132,1)',
		  	  				'rgba(54, 162, 235, 1)',
		  	  				'rgba(255, 206, 86, 1)',
		  	  				'rgba(75, 192, 192, 1)',
		  	  				'rgba(153, 102, 255, 1)',
		  	  				'rgba(255, 159, 64, 1)',
		  	  				'rgb(255,0,255)',
		  	  				'rgb(0,255,0)',
		  	  				'rgb(0,0,255)' ],
		  	                borderWidth: [2, 2, 2, 2, 2]
		  	            }
		  	        ]
		  	    };
		  	piechart && piechart.destroy();
		  	 piechart = new Chart(document.getElementById(data.id), {
		  		type: data.chart_Type,
		  			data:piechartdata,
		  			 options:{
		  				 
		  				onClick:function a(event,items){
		  					 var fieldName=data.field_name;
		  					 var clickValue=labeldata[items[0]._index];
		  					 drill(fieldName,clickValue);
		  				 
		  				 }
		  				 
		  			 }
		  		});
		  }

		  Chart.defaults.global.defaultFontColor = 'red';
		  Chart.defaults.global.defaultFontFamily = 'sans-serif';
		  Chart.defaults.global.defaultFontSize = 12;

//function doughnut...
		  	function doughnut(labeldata,labelcounts,data) {
		  	  var doughnutchartdata= {
		  	    			labels:labeldata,
		  	        datasets: [
		  	            {
		  	            	label:data.field_name,
		  	                data:labelcounts, 
		  	                backgroundColor : [
		  						'rgba(255, 99, 132, 0.2)',
		  						'rgba(54, 162, 235, 0.2)',
		  						'rgba(255, 206, 86, 0.2)',
		  						'rgba(75, 192, 192, 0.2)',
		  						'rgba(153, 102, 255, 0.2)',
		  						'rgba(255, 150, 255, 0.2)',
		  						'rgba(255,0,255,0.3)',
		  						'rgba(0,255,0,0.3)',
		  						'rgba(0,0,255,0.3)' ],
		  				borderColor : [
		  						'rgba(255,99,132,1)',
		  						'rgba(54, 162, 235, 1)',
		  						'rgba(255, 206, 86, 1)',
		  						'rgba(75, 192, 192, 1)',
		  						'rgba(153, 102, 255, 1)',
		  						'rgba(255, 159, 64, 1)',
		  						'rgb(255,0,255)',
		  						'rgb(0,255,0)',
		  						'rgb(0,0,255)' ],
		  	                borderWidth: [2, 2, 2, 2, 2]
		  	            }
		  	        ]
		  	    };
		  	doughnutchart && doughnutchart.destroy();
		  	 doughnutchart = new Chart(document.getElementById(data.id), {
		  		type: data.chart_Type,
		  			data:doughnutchartdata,
		  			 options:{
		  				 
		  				onClick:function a(event,items){
		  					 var fieldName=data.field_name;
		  					 var clickValue=labeldata[items[0]._index];
		  					 drill(fieldName,clickValue);
		  				 
		  				 }
		  			 }
		  		});
		  }

//function radar...		  	
		  	function radar(labeldata,labelcounts,data) {
		  	  var radarchartdata= {
		  	    			labels:labeldata,
		  	        datasets: [
		  	            {
		  	            	label:data.field_name,
		  	                data:labelcounts ,
		  	                backgroundColor : "rgba(0,255,0,0.3)",
		  	                borderColor : "rgb(0,255,0)",
		  	                borderWidth: 2
		  	            }
		  	        ]
		  	    };
		  radarchart &&	radarchart.destroy();
		  	  radarchart = new Chart(document.getElementById(data.id), {
		  		type: data.chart_Type,
		  			data:radarchartdata,
		  			 options:{
		  				 
		  				onClick:function a(event,items){
		  					 var fieldName=data.field_name;
		  					 var clickValue=labeldata[items[0]._index];
		  					 drill(fieldName,clickValue);
		  				 
		  				 }
		  			 }
		  		});
		  }
		  	
//function line...
		  function line(labeldata,labelcounts,data){
		  var linechartdata = {
		  		labels:labeldata,
		  		datasets: [
		  			{
		  		label:data.field_name,
		  		   data: labelcounts,	
		  		fill: true,
		  		lineTension: 0.1,
		  	backgroundColor : 'rgba(54, 162, 235, 0.2)',
		  	borderColor : 'rgba(54, 162, 235, 1)',	
		  	pointHoverBackgroundColor: 'rgba(54, 162, 235, 0.2)',
		  	pointHoverBorderColor: 'rgba(54, 162, 235, 1)',	
		  	},
		  ]
		  };
		 linechart && linechart.destroy();
		  linechart = new Chart(document.getElementById(data.id), {
		  type: data.chart_Type,
		  data:linechartdata ,
		  options:{
			  
			  onClick:function a(event,items){
					 var fieldName=data.field_name;
					 var clickValue=labeldata[items[0]._index];
					 drill(fieldName,clickValue);
				 
				 }
		  }
		  });
		  	}
		  	
//function polar...
		  function polar(labeldata,labelcounts,data) {
		  var polarchartdata= {
		  			labels:labeldata,
		      datasets: [
		          {
		          	label:data.field_name,
		              data:labelcounts, 
		              backgroundColor : [
		  				'rgba(255, 99, 132, 0.2)',
		  				'rgba(54, 162, 235, 0.2)',
		  				'rgba(255, 206, 86, 0.2)',
		  				'rgba(75, 192, 192, 0.2)',
		  				'rgba(153, 102, 255, 0.2)',
		  				'rgba(255, 150, 255, 0.2)',
		  				'rgba(255,0,255,0.3)',
		  				'rgba(0,255,0,0.3)',
		  				'rgba(0,0,255,0.3)' ],
		  		borderColor : [
		  				'rgba(255,99,132,1)',
		  				'rgba(54, 162, 235, 1)',
		  				'rgba(255, 206, 86, 1)',
		  				'rgba(75, 192, 192, 1)',
		  				'rgba(153, 102, 255, 1)',
		  				'rgba(255, 159, 64, 1)',
		  				'rgb(255,0,255)',
		  				'rgb(0,255,0)',
		  				'rgb(0,0,255)' ],
		              borderWidth: [2, 2, 2, 2, 2]
		          }
		      ]
		  };
		 polarchart && polarchart.destroy();
		  polarchart = new Chart(document.getElementById(data.id), {
		  type: data.chart_Type,
		  	data: polarchartdata,
		  	 options:{
		  		 
		  		onClick:function a(event,items){
 					 var fieldName=data.field_name;
 					 var clickValue=labeldata[items[0]._index];
 					 drill(fieldName,clickValue);
 				 
 				 }
		  	 }
		  });
		  }
		  
//function bar...
		  function bar(labeldata,labelcounts,data) { 
		  	 var barchartdata = {
		      		 labels:labeldata,
		          datasets: [
		              {      
		              	 label:data.field_name,
		                  data:labelcounts,
		                  backgroundColor : [
		  					'rgba(255, 99, 132, 0.2)',
		  					'rgba(54, 162, 235, 0.2)',
		  					'rgba(255, 206, 86, 0.2)',
		  					'rgba(75, 192, 192, 0.2)',
		  					'rgba(153, 102, 255, 0.2)',
		  					'rgba(255, 150, 255, 0.2)',
		  					'rgba(255,0,255,0.3)',
		  					'rgba(0,255,0,0.3)',
		  					'rgba(0,0,255,0.3)' ],
		  			borderColor : [
		  					'rgba(255,99,132,1)',
		  					'rgba(54, 162, 235, 1)',
		  					'rgba(255, 206, 86, 1)',
		  					'rgba(75, 192, 192, 1)',
		  					'rgba(153, 102, 255, 1)',
		  					'rgba(255, 159, 64, 1)',
		  					'rgb(255,0,255)',
		  					'rgb(0,255,0)',
		  					'rgb(0,0,255)' ],
		                  borderWidth: 2
		              }
		          ]
		      };
		  	barchart &&	barchart.destroy();
		  	        barchart = new Chart(document.getElementById(data.id), {
		   	        type: data.chart_Type, 
		   	        data: barchartdata,
		   	        options: {
		   	        	
		   	        	onClick:function a(event,items){
		  					 var fieldName=data.field_name;
		  					 var clickValue=labeldata[items[0]._index];
		  					 drill(fieldName,clickValue);
		  				 
		  				 }
		   	        }
		   	    });	
		  }
		  	
		  		}//for	
		  	},//success	end
		  	error : function(labeldata,labelcounts,data){
		  		alert("ok");
		  	}
		  	});//ajax calling end...
	  
  }//drill dunction
  
  

  //startup function.......
  $(document).ready(startup);	
  function startup(){
  $.ajax({
  	url :"Charts",
  	
  	type : "POST",
  	
  	dataType:"json",
  	
  	//on success time... 
  	success : function(dataa){
  	
  		for (var index in dataa){
  			
  			var labeldata=[];
  			var labelcounts=[];
  			data=dataa[index];
  		

  		$.each(data.bucketKeys, function(i, item) {
  			labeldata.push(item);
  		});
  		$.each(data.bucketCounts, function(i, item) {
  			labelcounts.push(item);
  		});
  	
  		if(data.chart_Type == "bar") {
  			bar(labeldata,labelcounts,data);	
  			}
  		else if (data.chart_Type == "pie") {
  			pie(labeldata,labelcounts,data);	
  		}
  		else if(data.chart_Type == "line") {
  			line(labeldata,labelcounts,data);
  		}
  		else if(data.chart_Type == "polarArea")
  			{
  			polar(labeldata,labelcounts,data);
  			}
  		else if(data.chart_Type == "doughnut")
  		{
  			doughnut(labeldata,labelcounts,data);
  		}
  		else if(data.chart_Type == "radar")
  		{
  			radar(labeldata,labelcounts,data);
  		}

 //function pie... 		
  function pie(labeldata,labelcounts,data) {
  	  var piechartdata= {
  	    			labels:labeldata,
  	        datasets: [
  	            {
  	            	label:data.field_name,
  	                data:labelcounts, 
  	              backgroundColor : [
  	  				'rgba(255, 99, 132, 0.2)',
  	  				'rgba(54, 162, 235, 0.2)',
  	  				'rgba(255, 206, 86, 0.2)',
  	  				'rgba(75, 192, 192, 0.2)',
  	  				'rgba(153, 102, 255, 0.2)',
  	  				'rgba(255, 150, 255, 0.2)',
  	  				'rgba(255,0,255,0.3)',
  	  				'rgba(0,255,0,0.3)',
  	  				'rgba(0,0,255,0.3)' ],
  	  		borderColor : [
  	  				'rgba(255,99,132,1)',
  	  				'rgba(54, 162, 235, 1)',
  	  				'rgba(255, 206, 86, 1)',
  	  				'rgba(75, 192, 192, 1)',
  	  				'rgba(153, 102, 255, 1)',
  	  				'rgba(255, 159, 64, 1)',
  	  				'rgb(255,0,255)',
  	  				'rgb(0,255,0)',
  	  				'rgb(0,0,255)' ],
  	                borderWidth: [2, 2, 2, 2, 2]
  	            }
  	        ]
  	    };
  	 piechart = new Chart(document.getElementById(data.id), {
  		type: data.chart_Type,
  			data:piechartdata,
  			 options:{
  				 
  				 onClick:function a(event,items){
  					 var fieldName=data.field_name;
  					 var clickValue=labeldata[items[0]._index];
  					 drill(fieldName,clickValue);
  				 
  				 }
  			 }
  		});
  }

  Chart.defaults.global.defaultFontColor = 'red';
  Chart.defaults.global.defaultFontFamily = 'sans-serif';
  Chart.defaults.global.defaultFontSize = 12;

 //function dougnut...
  	function doughnut(labeldata,labelcounts,data) {
  	  var doughnutchartdata= {
  	    			labels:labeldata,
  	        datasets: [
  	            {
  	            	label:data.field_name,
  	                data:labelcounts, 
  	                backgroundColor : [
  						'rgba(255, 99, 132, 0.2)',
  						'rgba(54, 162, 235, 0.2)',
  						'rgba(255, 206, 86, 0.2)',
  						'rgba(75, 192, 192, 0.2)',
  						'rgba(153, 102, 255, 0.2)',
  						'rgba(255, 150, 255, 0.2)',
  						'rgba(255,0,255,0.3)',
  						'rgba(0,255,0,0.3)',
  						'rgba(0,0,255,0.3)' ],
  				borderColor : [
  						'rgba(255,99,132,1)',
  						'rgba(54, 162, 235, 1)',
  						'rgba(255, 206, 86, 1)',
  						'rgba(75, 192, 192, 1)',
  						'rgba(153, 102, 255, 1)',
  						'rgba(255, 159, 64, 1)',
  						'rgb(255,0,255)',
  						'rgb(0,255,0)',
  						'rgb(0,0,255)' ],
  	                borderWidth: [2, 2, 2, 2, 2]
  	            }
  	        ]
  	    };
  	 doughnutchart = new Chart(document.getElementById(data.id), {
  		type: data.chart_Type,
  			data:doughnutchartdata,
  			 options:{
  				onClick:function a(event,items){
 					 var fieldName=data.field_name;
 					 var clickValue=labeldata[items[0]._index];
 					 drill(fieldName,clickValue);
 				 }
  			 }
  		});
  }
  	
 //function radar...
  	function radar(labeldata,labelcounts,data) {
  	  var radarchartdata= {
  	    			labels:labeldata,
  	        datasets: [
  	            {
  	            	label:data.field_name,
  	                data:labelcounts ,
  	                backgroundColor : "rgba(0,255,0,0.3)",
  	                borderColor : "rgb(0,255,0)",
  	                borderWidth: 2
  	            }
  	        ]
  	    };
  	  radarchart = new Chart(document.getElementById(data.id), {
  		type: data.chart_Type,
  			data:radarchartdata,
  			 options:{
  				onClick:function a(event,items){
 					 var fieldName=data.field_name;
 					 var clickValue=labeldata[items[0]._index];
 					 drill(fieldName,clickValue);
 				 }
  			 }
  		});
  }
  	
 //function line...
  function line(labeldata,labelcounts,data){
  var linechartdata = {
  		labels:labeldata,
  		datasets: [
  			{
  		label:data.field_name,
  		   data: labelcounts,	
  		fill: true,
  		lineTension: 0.1,
  		backgroundColor : 'rgba(54, 162, 235, 0.2)',
	  	borderColor : 'rgba(54, 162, 235, 1)',	
	  	pointHoverBackgroundColor: 'rgba(54, 162, 235, 0.2)',
	  	pointHoverBorderColor: 'rgba(54, 162, 235, 1)',	  	},
  ]
  };
  linechart = new Chart(document.getElementById(data.id), {
  type: data.chart_Type,
  data:linechartdata ,
  options:{
	  onClick:function a(event,items){
			 var fieldName=data.field_name;
			 var clickValue=labeldata[items[0]._index];
			 drill(fieldName,clickValue);
		 }
  }
  });
  	}
  	
  
 //function polar
  function polar(labeldata,labelcounts,data) {
  var polarchartdata= {
  			labels:labeldata,
      datasets: [
          {
          	label:data.field_name,
              data:labelcounts, 
              backgroundColor : [
  				'rgba(255, 99, 132, 0.2)',
  				'rgba(54, 162, 235, 0.2)',
  				'rgba(255, 206, 86, 0.2)',
  				'rgba(75, 192, 192, 0.2)',
  				'rgba(153, 102, 255, 0.2)',
  				'rgba(255, 150, 255, 0.2)',
  				'rgba(255,0,255,0.3)',
  				'rgba(0,255,0,0.3)',
  				'rgba(0,0,255,0.3)' ],
  		borderColor : [
  				'rgba(255,99,132,1)',
  				'rgba(54, 162, 235, 1)',
  				'rgba(255, 206, 86, 1)',
  				'rgba(75, 192, 192, 1)',
  				'rgba(153, 102, 255, 1)',
  				'rgba(255, 159, 64, 1)',
  				'rgb(255,0,255)',
  				'rgb(0,255,0)',
  				'rgb(0,0,255)' ],
              borderWidth: [2, 2, 2, 2, 2]
          }
      ]
  };
  polarchart = new Chart(document.getElementById(data.id), {
  type: data.chart_Type,
  	data: polarchartdata,
  	 options:{
  		onClick:function a(event,items){
				 var fieldName=data.field_name;
				 var clickValue=labeldata[items[0]._index];
				 drill(fieldName,clickValue);
			 }
  	 }
  });
  }
  
//function bar...
  function bar(labeldata,labelcounts,data) { 
  	 var barchartdata = {
      		 labels:labeldata,
          datasets: [
              {      
              	 label:data.field_name,
                  data:labelcounts,
                  backgroundColor : [
  					'rgba(255, 99, 132, 0.2)',
  					'rgba(54, 162, 235, 0.2)',
  					'rgba(255, 206, 86, 0.2)',
  					'rgba(75, 192, 192, 0.2)',
  					'rgba(153, 102, 255, 0.2)',
  					'rgba(255, 150, 255, 0.2)',
  					'rgba(255,0,255,0.3)',
  					'rgba(0,255,0,0.3)',
  					'rgba(0,0,255,0.3)' ],
  			borderColor : [
  					'rgba(255,99,132,1)',
  					'rgba(54, 162, 235, 1)',
  					'rgba(255, 206, 86, 1)',
  					'rgba(75, 192, 192, 1)',
  					'rgba(153, 102, 255, 1)',
  					'rgba(255, 159, 64, 1)',
  					'rgb(255,0,255)',
  					'rgb(0,255,0)',
  					'rgb(0,0,255)' ],
                  borderWidth: 2
              }
          ]
      };
  	        barchart = new Chart(document.getElementById(data.id), {
   	        type: data.chart_Type, 
   	        data: barchartdata,
   	        options: {
   	        	onClick:function a(event,items){
 					 var fieldName=data.field_name;
 					 var clickValue=labeldata[items[0]._index];
 					 drill(fieldName,clickValue);
 				 }
   	        }
   	    });	
  }
  	
  		}	
  	},//success end...
  	error : function(data){
  		alert("ok");
  	}
  	});   //ajax calling end...
  	}//function
  	
  </Script>
</body>
</html>