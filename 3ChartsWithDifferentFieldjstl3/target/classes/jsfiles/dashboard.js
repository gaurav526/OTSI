function startup() {
	$
			.ajax({
				url : "mbynameurl",
				dataType : 'json',
				type : "GET",
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

						$.each(response.bucketCounts, function(i, item) {
							labelcount.push(item);
						});

						if (response.chartType == "bar") {
							bar(labeldata, labelcount, response);
						} else if (response.chartType == "radar") {
							radar( labeldata, labelcount, response);
						} else if (response.chartType == "pie") {
							pie(labeldata, labelcount, response);
						} else if (response.chartType == "line") {
							line(labeldata, labelcount, response);
						} else if (response.chartType == "doughnut") {
							doughnut(labeldata, labelcount, response);
						} else if (response.chartType == "polarArea") {
							polarArea(labeldata, labelcount, response);
						}
						
						/* pie chart creation logic */
						function radar(labeldata, labelcount, response) {
							var s = new Chart(
									document.getElementById(response.id),
									{
										type : response.chartType,
										data : {
											labels : labeldata,
											datasets : [ {
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
												text : 'Predicted Maker names by count in pie Charts click on the makers and get body type'
											},

											onClick : function(event, item) {
												drill(event, item);
											}
										}
									});
						}

						/* pie chart creation logic */
						function pie( labeldata, labelcount, response) {
							var s = new Chart(
									document.getElementById(response.id),
									{
										type : response.chartType,
										data : {
											labels : labeldata,
											datasets : [ {
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
												text : 'Predicted Maker names by count in pie Charts click on the makers and get body type'
											},

											onClick : function(event, item) {
												drill(event, item);
											}
										}
									});
						}

						/* pie chart creation logic */
						function line(labeldata, labelcount, response) {
							var s = new Chart(
									document.getElementById(response.id),
									{
										type : response.chartType,
										data : {
											labels : labeldata,
											datasets : [ {
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
												text : 'Predicted Maker names by count in pie Charts click on the makers and get body type'
											},

											onClick : function(event, item) {
												drill(event, item);
											}
										}
									});
						}

						/* pie chart creation logic */
						function bar(labeldata, labelcount, response) {
							var s = new Chart(
									document.getElementById(response.id),
									{
										type : response.chartType,
										data : {
											labels : labeldata,
											datasets : [ {
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
												text : 'Predicted Maker names by count in pie Charts click on the makers and get body type'
											},

											onClick : function(event, item) {
												drill(event, item);
											}
										}
									});
						}

						/* pie chart creation logic */
						function doughnut(labeldata, labelcount, response) {
							var s = new Chart(
									document.getElementById(response.id),
									{
										type : response.chartType,
										data : {
											labels : labeldata,
											datasets : [ {
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
												text : 'Predicted Maker names by count in pie Charts click on the makers and get body type'
											},

											onClick : function(event, item) {
												drill(event, item);
											}
										}
									});
						}

						/* pie chart creation logic */
						function polarArea( labeldata, labelcount, response) {
							var s = new Chart(
									document.getElementById(response.id),
									{
										type : response.chartType,
										data : {
											labels : labeldata,
											datasets : [ {
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
														return  "'"+response.fieldname+"'"
																+ labeldata[tooltipItem.index]
																+ " Label_Count::"
																+ labelcount[tooltipItem.index];
													}
												}
											},

											title : {
												display : true,
												text : 'Predicted Maker names by count in pie Charts click on the makers and get body type'
											},

											onClick : function(event, item) {
												drill(event, item);
											},
											animation:true
										}
									});
						}
					}
				}
			});
}
$(document).ready(startup);