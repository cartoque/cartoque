require 'simple_form'
require 'simple_form/components/label_input'
require 'simple_form/inputs/boolean_input'

module SimpleForm
  mattr_accessor :label_input_builder
  @@label_input_builder = nil
end

module SimpleForm
  module Components
    module LabelInput
      def label_input_with_proc
        if label_input_builder && label_input_builder.is_a?(Proc)
          label_input_builder.call(label,input).html_safe
        else
          #(options[:label] == false ? "" : label) + input
          label_input_without_proc
        end
      end
      alias_method_chain :label_input, :proc
      
      def label_input_builder
        options[:label_input_builder] || SimpleForm.label_input_builder
      end
    end
  end
end

module SimpleForm
  module Inputs
    class BooleanInput
      def label_input
        super
      end
    end
  end
end
