
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<script src="Chart.min.js"></script>
<script src="jquery.min.js"></script>
<script src="jquery-1.12.4.js"></script>
<script src="jquery-ui.js"></script>
<script src="jspdf.plugin.from_html.js"></script>
<script src="jspdf.plugin.split_text_to_size.js"></script>
<script src="jspdf.js"></script>
<script src="jspdf.plugin.standard_fonts_metrics.js"></script>
<script src="dropdown.js">
	
</script>
<script
	src="http://cdnjs.cloudflare.com/ajax/libs/jspdf/1.3.3/jspdf.min.js"></script>

</head>
<jsp:include page="/mbynameurl" />
<body>


	<!-- <p id="ignorePDF">don't print this to pdf</p>
    <div>
      <p><font size="3" color="red">print this to pdf</font></p>
    </div> -->

	<h1>Hello jsp</h1>
	<h1 style="color: red; text-align: center">Dashboard</h1>
	<div id="pdffile">
		<table>
			<c:forEach var="ids" items="${allids}">
				<tr>
					<td>
						<canvas id="${ids }" width="400" height="350"></canvas>
					</td>
				</tr>
			</c:forEach>
		</table>
	</div>
	<button id="download">download as pdf</button>
	<div id="demon"></div>
	<script type="text/javascript">
	<c:forEach var="ids" items="${allids}">
		var canvas = document.getElementById("pdffile");
		//var context = canvas.getContext('2d');
		download.addEventListener("click", function() {
			var imgData = canvas.toDataURL("image/jpeg", 1.0);
			var pdf = new jsPDF();
			pdf.addImage(imgData, 'JPEG', 50, 50);
			pdf.save("download.pdf");
		}, false);
		</c:forEach>

		/* 		var doc = new jsPDF();

		 var specialElementHandlers = {
		 '#demon' : function(element, renderer) {
		 return true;
		 }
		 };
		 $('#download').click(function() {
		 doc.fromHTML($('#pdffile').html(), 50, 50, {
		 'width' : 170,
		 'elementHandlers' : specialElementHandlers
		 });
		 doc.save('sample-file.pdf');
		 });
		 */
		/* 
		var canvas = document.getElementById("pdffile");
		//var context = canvas.getContext('2d');
		
		download.addEventListener("click", function() {
			var pdf = new jsPDF();
			var imgData = canvas.toDataURL("image/jpeg", 1.0);
			
			pdf.addImage(imgData, 'JPEG',50,50);	
			pdf.save("download.pdf");
		}, false); */

		var barchart;
		var linechart;
		var doughnutchart;
		var radarchart;
		var piechart;
		var polarAreachart;
		function drill(fieldName, clickedFieldName) {
			$
					.ajax({
						url : "drill",
						dataType : "json",
						type : "GET",
						data : {
							fieldName : fieldName,
							clickedFieldName : clickedFieldName
						},
						error : function() {
							alert("Error Occured");
						},
						success : function(respons) {
							for ( var index in respons) {
								var labeldata = [];
								var labelcount = [];
								response = respons[index];
								$.each(response.bucketKeys, function(i, item) {
									labeldata.push(item);
								});
								$.each(response.bucketCounts,
										function(i, item) {
											labelcount.push(item);
										});
								if (response.chartType == "bar") {
									bar(labeldata, labelcount, response);
								} else if (response.chartType == "radar") {
									radar(labeldata, labelcount, response);
								} else if (response.chartType == "pie") {
									pie(labeldata, labelcount, response);
								} else if (response.chartType == "line") {
									line(labeldata, labelcount, response);
								} else if (response.chartType == "doughnut") {
									doughnut(labeldata, labelcount, response);
								} else if (response.chartType == "polarArea") {
									polarArea(labeldata, labelcount, response);
								}
								function bar(labeldata, labelcount, response) {
									barchart.destroy();
									barchart = new Chart(
											document
													.getElementById(response.id),
											{
												type : response.chartType,
												data : {
													labels : labeldata,
													datasets : [ {
														label : response.fieldname
																+ '  after drill',
														backgroundColor : [
																"rgba(255,0,0,0.3)",
																"rgba(0,255,0,0.3)",
																"rgba(0,0,255,0.3)",
																"rgba(192,192,192,0.3)",
																"rgba(255,255,0,0.3)",
																"#D2691E",
																"rgba(255,0,255,0.3)",
																"#6495ED" ],
														data : labelcount
													} ]
												},
												options : {
													tooltips : {
														callbacks : {
															label : function(
																	tooltipItem) {
																return "Label_data::"
																		+ labeldata[tooltipItem.index]
																		+ " Label_Count::"
																		+ labelcount[tooltipItem.index];
															}
														}
													},
													title : {
														display : true,
														text : 'Predicted  '
																+ response.fieldname
																+ '  based on drill'
													},
													onClick : function(event,
															item) {
														var fieldName = response.fieldname;
														var clickedValue = labeldata[item[0]._index];
														drill(fieldName,
																clickedValue);
													}
												}
											});
								}
								function polarArea(labeldata, labelcount,
										response) {
									polarAreachart.destroy();
									polarAreachart = new Chart(
											document
													.getElementById(response.id),
											{
												type : response.chartType,
												data : {
													labels : labeldata,
													datasets : [ {
														label : response.fieldname
																+ '  after drill',
														backgroundColor : [
																"rgba(255,0,0,0.3)",
																"rgba(0,255,0,0.3)",
																"rgba(0,0,255,0.3)",
																"rgba(192,192,192,0.3)",
																"rgba(255,255,0,0.3)",
																"#D2691E",
																"rgba(255,0,255,0.3)",
																"#6495ED" ],
														data : labelcount
													} ]
												},
												options : {
													tooltips : {
														callbacks : {
															label : function(
																	tooltipItem) {
																return "Label_data::"
																		+ labeldata[tooltipItem.index]
																		+ " Label_Count::"
																		+ labelcount[tooltipItem.index];
															}
														}
													},

													title : {
														display : true,
														text : 'Predicted  '
																+ response.fieldname
																+ '  based on drill'
													},
													onClick : function(event,
															item) {
														var fieldName = response.fieldname;
														var clickedValue = labeldata[item[0]._index];
														drill(fieldName,
																clickedValue);
													}
												}
											});

								}
								function radar(labeldata, labelcount, response) {
									radarchart.destroy();
									radarchart = new Chart(
											document
													.getElementById(response.id),
											{
												type : response.chartType,
												data : {
													labels : labeldata,
													datasets : [ {
														label : response.fieldname
																+ '  after drill',
														backgroundColor : [
																"rgba(255,0,0,0.3)",
																"rgba(0,255,0,0.3)",
																"rgba(0,0,255,0.3)",
																"rgba(192,192,192,0.3)",
																"rgba(255,255,0,0.3)",
																"#D2691E",
																"rgba(255,0,255,0.3)",
																"#6495ED" ],
														data : labelcount
													} ]
												},
												options : {
													tooltips : {
														callbacks : {
															label : function(
																	tooltipItem) {
																return "Label_data::"
																		+ labeldata[tooltipItem.index]
																		+ " Label_Count::"
																		+ labelcount[tooltipItem.index];
															}
														}
													},

													title : {
														display : true,
														text : 'Predicted  '
																+ response.fieldname
																+ '  based on drill'
													},
													onClick : function(event,
															item) {
														var fieldName = response.fieldname;
														var clickedValue = labeldata[item[0]._index];
														drill(fieldName,
																clickedValue);
													}
												}
											});
								}
								function pie(labeldata, labelcount, response) {
									piechart.destroy();
									piechart = new Chart(
											document
													.getElementById(response.id),
											{
												type : response.chartType,
												data : {
													labels : labeldata,
													datasets : [ {
														label : response.fieldname
																+ '  after drill',
														backgroundColor : [
																"rgba(255,0,0,0.3)",
																"rgba(0,255,0,0.3)",
																"rgba(0,0,255,0.3)",
																"rgba(192,192,192,0.3)",
																"rgba(255,255,0,0.3)",
																"#D2691E",
																"rgba(255,0,255,0.3)",
																"#6495ED" ],
														data : labelcount
													} ]
												},
												options : {
													tooltips : {
														callbacks : {
															label : function(
																	tooltipItem) {
																return "Label_data::"
																		+ labeldata[tooltipItem.index]
																		+ " Label_Count::"
																		+ labelcount[tooltipItem.index];
															}
														}
													},

													title : {
														display : true,
														text : 'Predicted  '
																+ response.fieldname
																+ '  based on drill'
													},
													onClick : function(event,
															item) {
														var fieldName = response.fieldname;
														var clickedValue = labeldata[item[0]._index];
														drill(fieldName,
																clickedValue);
													}
												}
											});
								}
								function doughnut(labeldata, labelcount,
										response) {
									doughnutchart.destroy();
									doughnutchart = new Chart(
											document
													.getElementById(response.id),
											{
												type : response.chartType,
												data : {
													labels : labeldata,
													datasets : [ {
														label : response.fieldname
																+ '  after drill',
														backgroundColor : [
																"rgba(255,0,0,0.3)",
																"rgba(0,255,0,0.3)",
																"rgba(0,0,255,0.3)",
																"rgba(192,192,192,0.3)",
																"rgba(255,255,0,0.3)",
																"#D2691E",
																"rgba(255,0,255,0.3)",
																"#6495ED" ],
														data : labelcount
													} ]
												},
												options : {
													tooltips : {
														callbacks : {
															label : function(
																	tooltipItem) {
																return "Label_data::"
																		+ labeldata[tooltipItem.index]
																		+ " Label_Count::"
																		+ labelcount[tooltipItem.index];
															}
														}
													},

													title : {
														display : true,
														text : 'Predicted  '
																+ response.fieldname
																+ '  based on drill'
													},
													onClick : function(event,
															item) {
														var fieldName = response.fieldname;
														var clickedValue = labeldata[item[0]._index];
														drill(fieldName,
																clickedValue);
													}
												}
											});
								}
								function line(labeldata, labelcount, response) {
									linechart.detstroy();
									linechart = new Chart(
											document
													.getElementById(response.id),
											{
												type : response.chartType,
												data : {
													labels : labeldata,
													datasets : [ {
														label : response.fieldname
																+ '  after drill',
														backgroundColor : [
																"rgba(255,0,0,0.3)",
																"rgba(0,255,0,0.3)",
																"rgba(0,0,255,0.3)",
																"rgba(192,192,192,0.3)",
																"rgba(255,255,0,0.3)",
																"#D2691E",
																"rgba(255,0,255,0.3)",
																"#6495ED" ],
														data : labelcount
													} ]
												},
												options : {
													tooltips : {
														callbacks : {
															label : function(
																	tooltipItem) {
																return "Label_data::"
																		+ labeldata[tooltipItem.index]
																		+ " Label_Count::"
																		+ labelcount[tooltipItem.index];
															}
														}
													},

													title : {
														display : true,
														text : 'Predicted  '
																+ response.fieldname
																+ '  based on drill'
													},
													onClick : function(event,
															item) {
														var fieldName = response.fieldname;
														var clickedValue = labeldata[item[0]._index];
														drill(fieldName,
																clickedValue);
													}
												}
											});
								}
							}
						}
					});
		}
		function startup() {
			alert("hello");
			$
					.ajax({
						url : "mbynameurl",
						dataType : 'json',
						type : "POST",
						error : function() {
							alert("Error Occured");
						},
						success : function(respons) {
							for ( var index in respons) {
								var labeldata = [];
								var labelcount = [];
								response = respons[index];
								$.each(response.bucketKeys, function(i, item) {
									labeldata.push(item);
								});

								$.each(response.bucketCounts,
										function(i, item) {
											labelcount.push(item);
										});

								if (response.chartType == "bar") {
									bar(labeldata, labelcount, response);
								} else if (response.chartType == "radar") {
									radar(labeldata, labelcount, response);
								} else if (response.chartType == "pie") {
									pie(labeldata, labelcount, response);
								} else if (response.chartType == "line") {
									line(labeldata, labelcount, response);
								} else if (response.chartType == "doughnut") {
									doughnut(labeldata, labelcount, response);
								} else if (response.chartType == "polarArea") {
									polarArea(labeldata, labelcount, response);
								}
								function bar(labeldata, labelcount, response) {
									barchart = new Chart(
											document
													.getElementById(response.id),
											{
												type : response.chartType,

												data : {

													labels : labeldata,
													datasets : [ {
														label : response.fieldname,
														backgroundColor : [
																"rgba(255,0,0,0.3)",
																"rgba(0,255,0,0.3)",
																"rgba(0,0,255,0.3)",
																"rgba(192,192,192,0.3)",
																"rgba(255,255,0,0.3)",
																"#D2691E",
																"rgba(255,0,255,0.3)",
																"#6495ED" ],
														data : labelcount
													} ]
												},
												options : {
													tooltips : {
														callbacks : {
															label : function(
																	tooltipItem) {
																return "Label_data::"
																		+ labeldata[tooltipItem.index]
																		+ " Label_Count::"
																		+ labelcount[tooltipItem.index];
															}
														}
													},
													title : {
														display : true,
														text : 'Predicted  '
																+ response.fieldname
													},

													onClick : function(event,
															item) {
														var fieldName = response.fieldname;
														var clickedFieldName = labeldata[item[0]._index];
														drill(fieldName,
																clickedFieldName);
													}
												}
											});
								}
								function doughnut(labeldata, labelcount,
										response) {
									doughnutchart = new Chart(
											document
													.getElementById(response.id),
											{
												type : response.chartType,
												data : {
													labels : labeldata,
													datasets : [ {
														label : response.fieldname,
														backgroundColor : [
																"rgba(255,0,0,0.3)",
																"rgba(0,255,0,0.3)",
																"rgba(0,0,255,0.3)",
																"rgba(192,192,192,0.3)",
																"rgba(255,255,0,0.3)",
																"#D2691E",
																"rgba(255,0,255,0.3)",
																"#6495ED" ],
														data : labelcount
													} ]
												},
												options : {
													tooltips : {
														callbacks : {
															label : function(
																	tooltipItem) {
																return "Label_data::"
																		+ labeldata[tooltipItem.index]
																		+ " Label_Count::"
																		+ labelcount[tooltipItem.index];
															}
														}
													},
													title : {
														display : true,
														text : 'Predicted  '
																+ response.fieldname
													},
													onClick : function(event,
															item) {
														var fieldName = response.fieldname;
														var clickedFieldName = labeldata[item[0]._index];
														drill(fieldName,
																clickedFieldName);
													}
												}
											});
								}
								function radar(labeldata, labelcount, response) {
									radarchart = new Chart(
											document
													.getElementById(response.id),
											{
												type : response.chartType,
												data : {
													labels : labeldata,
													datasets : [ {
														label : response.fieldname,
														backgroundColor : [
																"rgba(255,0,0,0.3)",
																"rgba(0,255,0,0.3)",
																"rgba(0,0,255,0.3)",
																"rgba(192,192,192,0.3)",
																"rgba(255,255,0,0.3)",
																"#D2691E",
																"rgba(255,0,255,0.3)",
																"#6495ED" ],
														data : labelcount
													} ]
												},
												options : {
													tooltips : {
														callbacks : {
															label : function(
																	tooltipItem) {
																return "Label_data::"
																		+ labeldata[tooltipItem.index]
																		+ " Label_Count::"
																		+ labelcount[tooltipItem.index];
															}
														}
													},

													title : {
														display : true,
														text : 'Predicted  '
																+ response.fieldname
													},
													onClick : function(event,
															item) {
														var fieldName = response.fieldname;
														var clickedFieldName = labeldata[item[0]._index];
														drill(fieldName,
																clickedFieldName);
													}
												}
											});
								}
								function pie(labeldata, labelcount, response) {
									piechart = new Chart(
											document
													.getElementById(response.id),
											{
												type : response.chartType,
												data : {
													labels : labeldata,
													datasets : [ {
														label : response.fieldname,
														backgroundColor : [
																"rgba(255,0,0,0.3)",
																"rgba(0,255,0,0.3)",
																"rgba(0,0,255,0.3)",
																"rgba(192,192,192,0.3)",
																"rgba(255,255,0,0.3)",
																"#D2691E",
																"rgba(255,0,255,0.3)",
																"#6495ED" ],
														data : labelcount
													} ]
												},
												options : {
													tooltips : {
														callbacks : {
															label : function(
																	tooltipItem) {
																return "Label_data::"
																		+ labeldata[tooltipItem.index]
																		+ " Label_Count::"
																		+ labelcount[tooltipItem.index];
															}
														}
													},
													title : {
														display : true,
														text : 'Predicted  '
																+ response.fieldname
													},
													onClick : function(event,
															item) {
														var fieldName = response.fieldname;
														var clickedFieldName = labeldata[item[0]._index];
														drill(fieldName,
																clickedFieldName);
													}
												}
											});
								}
								function line(labeldata, labelcount, response) {
									linechart = new Chart(
											document
													.getElementById(response.id),
											{
												type : response.chartType,
												data : {
													labels : labeldata,
													datasets : [ {
														label : response.fieldname,
														backgroundColor : [
																"rgba(255,0,0,0.3)",
																"rgba(0,255,0,0.3)",
																"rgba(0,0,255,0.3)",
																"rgba(192,192,192,0.3)",
																"rgba(255,255,0,0.3)",
																"#D2691E",
																"rgba(255,0,255,0.3)",
																"#6495ED" ],
														data : labelcount
													} ]
												},
												options : {
													tooltips : {
														callbacks : {
															label : function(
																	tooltipItem) {
																return "Label_data::"
																		+ labeldata[tooltipItem.index]
																		+ " Label_Count::"
																		+ labelcount[tooltipItem.index];
															}
														}
													},
													title : {
														display : true,
														text : 'Predicted  '
																+ response.fieldname
													},
													onClick : function(event,
															item) {
														var fieldName = response.fieldname;
														var clickedFieldName = labeldata[item[0]._index];
														drill(fieldName,
																clickedFieldName);
													}
												}
											});
								}
								function polarArea(labeldata, labelcount,
										response) {
									polarAreachart = new Chart(
											document
													.getElementById(response.id),
											{
												type : response.chartType,
												data : {
													labels : labeldata,
													datasets : [ {
														label : response.fieldname,
														backgroundColor : [
																"rgba(255,0,0,0.3)",
																"rgba(0,255,0,0.3)",
																"rgba(0,0,255,0.3)",
																"rgba(192,192,192,0.3)",
																"rgba(255,255,0,0.3)",
																"#D2691E",
																"rgba(255,0,255,0.3)",
																"#6495ED" ],
														data : labelcount
													} ]
												},
												options : {
													tooltips : {
														callbacks : {
															label : function(
																	tooltipItem) {
																return "Label_data::"
																		+ labeldata[tooltipItem.index]
																		+ " Label_Count::"
																		+ labelcount[tooltipItem.index];
															}
														}
													},
													title : {
														display : true,
														text : 'Predicted  '
																+ response.fieldname
													},
													onClick : function(event,
															item) {
														var fieldName = response.fieldname;
														var clickedFieldName = labeldata[item[0]._index];
														drill(fieldName,
																clickedFieldName);
													}
												}
											});
								}
							}
						}
					});
		}
		$(document).ready(startup);
		console.log(barchart);
		console.log(linechart);
		console.log(doughnutchart);
		console.log(radarchart);
		console.log(piechart);
		console.log(polarAreachart);
	</script>
</body>
</html>