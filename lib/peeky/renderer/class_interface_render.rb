# frozen_string_literal: true

module Peeky
  module Renderer
    # Render: Class Interface
    #
    # Example output:
    # class SampleClassClassInterfaceRender
    #   attr_accessor :a
    #
    #   attr_reader :b
    #
    #   attr_writer :c
    #
    #   def alpha_sort1;                                                                end
    #   def alpha_sort2;                                                                end
    #   def d;                                                                          end
    #   def e(aaa);                                                                     end
    #   def f(aaa, bbb = nil);                                                          end
    #   def g(aaa, bbb = nil, ccc = nil);                                               end
    #   def h(*aaa);                                                                    end
    #   def i(aaa, bbb, *ccc);                                                          end
    #   def j(**aaa);                                                                   end
    #   def k(aaa, *bbb, **ccc);                                                        end
    #   def l(aaa, *bbb, **ccc, &ddd);                                                  end
    #   def m(aaa:);                                                                    end
    #   def n(aaa:, bbb: nil);                                                          end
    #   def p?;                                                                         end
    #   def q!;                                                                         end
    #   def z(aaa, bbb = nil, *ccc, ddd:, eee: nil, **fff, &ggg);                       end
    # end
    class ClassInterfaceRender
      # ClassInfo with information about the class instance to be rendered.
      attr_reader :class_info

      def initialize(class_info)
        @class_info = class_info
      end

      # Render the class interface
      def render
        @indent = ''
        output = []
        output.push render_start
        @indent = '  '
        output += render_accessors
        output += render_readers
        output += render_writers
        output += render_methods
        output.pop if output.last == ''

        @indent = ''
        output.push render_end

        output.join("\n")
      end

      private

      def render_start
        "#{@indent}class #{@class_info.class_name}"
      end

      def render_accessors
        result = @class_info.accessors.map { |attr| "#{@indent}attr_accessor :#{attr.name}" }
        result.push '' unless result.length.zero?
        result
      end

      def render_readers
        result = @class_info.readers.map { |attr| "#{@indent}attr_reader :#{attr.name}" }
        result.push '' unless result.length.zero?
        result
      end

      def render_writers
        result = @class_info.writers.map { |attr| "#{@indent}attr_writer :#{attr.name}" }
        result.push '' unless result.length.zero?
        result
      end

      def render_methods
        result = @class_info.methods.map do |method_signature|
          render_signature = Peeky::Renderer::MethodSignatureRender.new(method_signature)
          "#{@indent}#{render_signature.render}"
        end
        result.push '' unless result.length.zero?
        result
      end

      def render_end
        "#{@indent}end"
      end
    end
  end
end
