jQuery ->
  $field = $('#contact_company_name')
  $field.autocomplete
    source: $field.data('autocomplete-source')

jQuery ->
  $wrapper = $('.image_url_form .image')
  $image = $wrapper.find('img')
  $image.click ->
    a = $image.attr('src').split('/')
    current_image_basename = a[a.length - 1]
    next_image_basename = $wrapper.data('image-urls')[current_image_basename]
    if next_image_basename != undefined
      a[a.length - 1] = next_image_basename
      $image.attr('src', a.join('/'))
      $('.image_url_form').find('input[type=hidden]').attr('value', next_image_basename)
