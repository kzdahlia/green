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

});
