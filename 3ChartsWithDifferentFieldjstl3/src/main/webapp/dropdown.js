/**
 * 
 */
$( function() {
    $( "#pie1, #pie2,#chart1,#chart2" ).sortable({
      connectWith: ".c"
    }).disableSelection();
  } );