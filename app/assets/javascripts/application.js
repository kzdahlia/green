//= require jquery
//= require jquery_ujs
//= require bootstrap
$(document).ready(function(){
  $('[data-type=form_request]').each(function(){
    var bt = $(this);
    bt.on('click', function(){
      var form = bt.parents('form');
      $('input[name=_method]', form).attr('value', bt.attr('data-method'));
      console.log(bt.attr('data-action'));
      if(bt.attr('data-action')) {
        form.attr('action', bt.attr('data-action'));
      }
      form.submit();
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
  
});


function init_pic_size(dom) {
  var img = $("img", dom)
  img.width(105);
  img.height(105);
}


