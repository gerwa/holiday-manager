$(document).ready(function() {

  editRow();

});

function editRow() {
    $(".editRow").on("click",function() {
        var td = $(this).parent();
        var tr = td.parent();
        //change the background color to red before removing
        tr.css("background-color","#F6CECE");
        $('.edit-form').toggle();
    });
}

function toggleAddMask(addMaskId) {
  $(addMaskId).toggle();
}  

