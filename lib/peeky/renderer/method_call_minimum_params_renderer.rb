# frozen_string_literal: true

module Peeky
  module Renderer
    # Render a method Call with minimum parameters
    #
    # Example output:
    #   instance.simple('first_param')
    #   instance.complex('aaa', ddd: 'ddd')
    class MethodCallMinimumParamsRenderer
      attr_reader :method_signature

      def initialize(method_signature, instance_name = 'instance')
        @instance_name = instance_name
        @method_signature = method_signature
      end

      def render
        name = method_signature.name

        minimal_call_parameters = method_signature
                                  .parameters
                                  .map(&:minimal_call_format)
                                  .reject { |minimal_call| minimal_call.nil? || minimal_call.strip.empty? }
                                  .join(', ')

        params = minimal_call_parameters.length.zero? ? '' : "(#{minimal_call_parameters})"

        "#{@instance_name}.#{name}#{params}"
      end

      def debug
        puts render
      end
    end
  end
end
