select2_handler = ->
  $('.select2').each (i, e) =>
    select = $(e)
    options =
      placeholder: select.data('placeholder')
      allowClear: true
      containerCss: {"display":"block"}
    select.select2(options)

$(document).ready(select2_handler);
$(document).on('page:load', select2_handler);