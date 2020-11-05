# frozen_string_literal: true

module Peeky
  module Renderer
    # Render: Method Signature in compact format
    #
    # Example output:
    #   def simple(first_param);                                           end
    #   def complex(aaa, bbb = nil, *ccc, ddd:, eee: nil, **fff, &ggg);    end
    class MethodSignatureRender
      attr_accessor :indent
      attr_accessor :style

      attr_reader :method_signature

      def initialize(method_signature, **_opts)
        @method_signature = method_signature
        @indent = ''
        @style = :compact
      end

      def render_signature
        name = method_signature.name

        formatted_parameters = method_signature.parameters.map(&:signature_format).join(', ')
        params = formatted_parameters.length.zero? ? '' : "(#{formatted_parameters})"
        "#{@indent}def #{name}#{params}"
      end

      def render_end
        "#{@indent}end"
      end

      def render
        output = []
        if @style == :compact
          signature = "#{render_signature};"
          output.push "#{signature.ljust(80)}#{render_end}"
        end
        if @style == :default
          output.push render_signature
          output.push render_end
        end
        output.join("\n")
      end

      def debug
        puts render
      end
    end
  end
end
