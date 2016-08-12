//----------------
// DOCUMENT READY
//----------------

$(document).ready(function()
{                                  
  //Select all check boxes
  $("#check_all").on("click",function()
  {
    var chk_arr =  document.getElementsByName("media_ids[]");
    var chklength = chk_arr.length;
    var flag =  $('#check_all').val();

    for(k=0; k < chklength; k++)
    {
      if(flag === 'false')
      {
        chk_arr[k].checked = true;
        $('#check_all').val('true');
      }
      else {
        chk_arr[k].checked = false;
        $('#check_all').val('false');
      }
    } 
  });

  //Select all check boxes for courses
  $("#check_all_courses").on("click",function()
  {
    var chk_arr =  document.getElementsByName("course_ids[]");
    var chklength = chk_arr.length;
    var flag =  $('#check_all_courses').val();

    for(k=0; k < chklength; k++)
    {
      if(flag === 'false')
      {
        chk_arr[k].checked = true;
        $('#check_all_courses').val('true');
      }
      else {
        chk_arr[k].checked = false;
        $('#check_all_courses').val('false');
      }
    } 
  });
});