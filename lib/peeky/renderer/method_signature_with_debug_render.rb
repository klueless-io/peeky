# frozen_string_literal: true

module Peeky
  module Renderer
    # Render: Method signature with debug code
    # Stubbed Method Render
    #
    # Example output:
    #   def simple(first_param)
    #     puts 'method name: simple'
    #     puts first_param                    # first_param is a required positional paramater
    #   end
    #
    #   def complex(aaa, bbb = nil, *ccc, ddd:, eee: nil, **fff, &ggg)
    #     puts 'method name: complex'
    #     puts aaa                            # aaa is a required positional paramater
    #     puts bbb                            # bbb is an optional positional paramater
    #     puts ccc                            # *ccc takes a list of positional params
    #     puts ddd                            # ddd: is a required named parameter
    #     puts eee                            # eee: is an optional named parameter
    #     puts fff                            # **fff takes a list of optional named parameters
    #     puts ggg                            # &ggg is block with many calling options, example - instance_eval(&block) if block_given?
    #   end
    class MethodSignatureWithDebugRender
      # Method signature stores a MethodInfo object
      attr_reader :method_signature

      def initialize(method_signature, **_opts)
        @method_signature = method_signature

        @render_signature = Peeky::Renderer::MethodSignatureRender.new(method_signature)
      end

      # Render the method with debug statements for each parameter
      def render
        render_method
      end

      private

      def render_method
        name = method_signature.name

        indent = ''
        output = "#{indent}#{@render_signature.render_signature}\n"
        indent = '  '
        output += "#{indent}puts 'method name: #{name}'\n"

        output += render_debug_logic(indent, 30)

        indent = ''
        output += "#{indent}#{@render_signature.render_end}\n"

        output
      end

      # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
      def render_debug_logic(indent, size)
        output = ''
        method_signature.parameters.each do |parameter|
          line = ''
          case parameter.type
          when :param_required
            line = "puts #{parameter.name.ljust(size)} # #{parameter.name} is a required positional paramater"
          when :param_optional
            line = "puts #{parameter.name.ljust(size)} # #{parameter.name} is an optional positional paramater"
          when :splat
            line = "puts #{parameter.name.ljust(size)} # *#{parameter.name} takes a list of positional params"
          when :key_required
            line = "puts #{parameter.name.ljust(size)} # #{parameter.name}: is a required named parameter"
          when :key_optional
            line = "puts #{parameter.name.ljust(size)} # #{parameter.name}: is an optional named parameter"
          when :double_splat
            line = "puts #{parameter.name.ljust(size)} # **#{parameter.name} takes a list of optional named parameters"
          when :block
            line = "puts #{parameter.name.ljust(size)} # &#{parameter.name} is block with many calling options, example - instance_eval(&block) if block_given?"
          end

          output += "#{indent}#{line}\n"
        end
        output
      end
      # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity
    end
  end
end
