$(document).ready(function() {

     
    $('.order-filter').DataTable( {
        "order": [[ 1, "asc" ]],
        //"bFilter": true,
        "bInfo": false,
        "bLengthChange": false,
        "bPaginate": false
    } );

    $('.order-filter tfoot th').each( function () {
          var title = $(this).text();
          $(this).html( '<input type="text" placeholder="Suche '+title+'" />' );
      } );
   
      // DataTable
      var table = $('.order-filter').DataTable();
   
      // Apply the search
      table.columns().every( function () {
          var that = this;
   
          $( 'input', this.footer() ).on( 'keyup change', function () {
              if ( that.search() !== this.value ) {
                  that
                      .search( this.value )
                      .draw();
              }
          } );
      } );

      
} );
