//= require jquery
//= require jquery_ujs
//= require bootstrap
$(document).ready(function(){
  $('[data-type=form_request]').each(function(){
    var bt = $(this);
    bt.on('click', function(){
      var form = bt.parents('form');
      $('input[name=_method]', form).attr('value', bt.attr('data-method'));
      if(bt.attr('data-action')) {
        form.attr('action', bt.attr('data-action'));
      }
      if(check_checked_count()) {
        form.submit();
      } else {
        alert("請選擇至少一張圖片");
      }
      return false;
    });
  });

  $('[data-type=foto]').each(function(){
    init_pic_size(this);
  });

  $('input[data-type=fade]').each(function(){
    var to = $('img', $(this).parents($(this).attr('data-to')));
    $(this).on('change', function(){
      if(this.checked) {
        to.fadeTo(0, 0.5);
      } else {
        to.fadeTo(0, 1);
      }
    });
  });
  

  $('input[data-type=append_tag]').each(function(){
    var user_id = $(this).attr('data-user_id');
    var to = $($(this).attr('data-to'))
    $(this).on('click', function(){
      var text_input = $($(this).attr('data-from'));
      var tag_name = text_input.attr("value");
      text_input.attr("value", "");
      $.post("/users/"+user_id+"/tags.html", { "tag": { "name": tag_name } }, function(data){
        to.append(data);
      });
    });
  });
  
  $('input.foto_checked').each(function(){
    var to = $('span#foto_checked');
    if(this.checked) {
      check_counter_append(to, 1);
    }
    $(this).on('change', function(){
      if(this.checked) {
        check_counter_append(to, 1);
      } else {
        check_counter_append(to, -1);
      }
    });
  });

  $('.tags').button();
});

function check_checked_count() {
  if($('span#foto_checked').html() == "0") {
    return false;
  } else {
    return true;
  }
}


function check_counter_append(to, num) {
  var number = parseInt(to.html())
  number = number + num
  to.html(number);
}

function init_pic_size(dom) {
  var img = $("img", dom)
  img.width(105);
  img.height(105);
}


