class MultiselectInput < SimpleForm::Inputs::CollectionInput
  include ActionView::Helpers::FormTagHelper

  def input
    label_method, value_method = detect_collection_methods

    @builder.send(:"collection_select", attribute_name, collection,
                  value_method, label_method, input_options, input_html_options)
      hidden_field_tag("#{object_name}[#{attribute_name}][]", "")
  end
 
  def input_options
    options = super
    options[:include_blank] = false
    options[:prompt] = false
    Rails.logger.error options.inspect
    options
  end

  def input_html_options
    options = super
    options[:multiple] = true
    options
  end
end
