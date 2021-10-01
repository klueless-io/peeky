# frozen_string_literal: true

module Peeky
  module Renderer
    # Render: Simple instance method calls with minimum parameters
    #
    # Example output:
    #   instance.simple('first_param')
    #   instance.complex('aaa', ddd: 'ddd')
    class MethodCallMinimumParamsRender
      # Method signature stores a MethodInfo object
      attr_reader :method_signature

      def initialize(method_signature, **opts)
        # instance_name = opts[:instance_name] || 'instance'
        @instance_name    = opts[:instance_name]
        @class_name       = opts[:class_name]
        @method_signature = method_signature
      end

      # Render the a method call with minimal parameters
      def render
        name = method_signature.name

        minimal_call_parameters = method_signature
                                  .parameters
                                  .map(&:minimal_call_format)
                                  .reject { |minimal_call| minimal_call.nil? || minimal_call.strip.empty? }
                                  .join(', ')

        params = minimal_call_parameters.length.zero? ? '' : "(#{minimal_call_parameters})"

        return "#{@instance_name}.#{name}#{params}" unless @instance_name.nil?
        return "#{@class_name}.#{name}#{params}" unless @class_name.nil?

        "#{name}#{params}"
      end
    end
  end
end
