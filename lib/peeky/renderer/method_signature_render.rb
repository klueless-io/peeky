# frozen_string_literal: true

module Peeky
  module Renderer
    # Render: Method Signature in compact format
    #
    # === Example output (:default):
    #   def simple(first_param)
    #   end
    #
    #   def complex(aaa, bbb = nil, *ccc, ddd:, eee: nil, **fff, &ggg)
    #   end
    #
    # === Example output (:compact):
    #   def simple(first_param);                                           end
    #   def complex(aaa, bbb = nil, *ccc, ddd:, eee: nil, **fff, &ggg);    end
    class MethodSignatureRender
      # Indentation prefix as a string.
      #
      # Defaults to ''
      #
      # If you were writing a class into a file with an existing
      # module, you may set the indent to '  ' if you wanted this
      # render to indent by two spaces
      attr_accessor :indent

      # Style of method rendering [:default, :compact]
      #
      # default:: will render +def method_name+ and +end+ on separate lines
      # compact:: will render +def method_name+ and +end+ on same line
      # @return [Symbol] style
      attr_accessor :style

      # Method signature stores a MethodInfo object
      attr_reader :method_signature

      def initialize(method_signature, **_opts)
        @method_signature = method_signature
        @indent = ''
        @style = :compact
      end

      # Render the method signature in the selected style
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

      def render_signature
        name = method_signature.name

        formatted_parameters = method_signature.parameters.map(&:signature_format).join(', ')
        params = formatted_parameters.length.zero? ? '' : "(#{formatted_parameters})"
        "#{@indent}def #{name}#{params}"
      end

      def render_end
        "#{@indent}end"
      end
    end
  end
end
