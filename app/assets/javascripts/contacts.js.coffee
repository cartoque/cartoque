jQuery ->
  $field = $('#contact_company_name')
  $field.autocomplete
    source: $field.data('autocomplete-source')
