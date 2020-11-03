# frozen_string_literal: true

module Peeky
  module Renderer
    # Method Signature Render
    #
    # Example output:
    #   def simple(first_param);                                           end
    #   def complex(aaa, bbb = nil, *ccc, ddd:, eee: nil, **fff, &ggg);    end
    class MethodSignatureRender
      attr_reader :method_signature

      def initialize(method_signature)
        @method_signature = method_signature
      end

      def render_signature
        name = method_signature.name

        formatted_parameters = method_signature.parameters.map(&:signature_format).join(', ')
        params = formatted_parameters.length.zero? ? '' : "(#{formatted_parameters})"
        "def #{name}#{params}"
      end

      def render_end
        'end'
      end

      def render
        signature = "#{render_signature};"
        "#{signature.ljust(80)}#{render_end}"
      end

      def debug
        puts render
      end
    end
  end
end
