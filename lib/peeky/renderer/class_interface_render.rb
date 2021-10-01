# frozen_string_literal: true

module Peeky
  module Renderer
    # Render: Class Interface Example
    #
    # class ComplexClass
    #   attr_accessor :a_read_write1
    #   attr_accessor :a_read_write2

    #   attr_reader :b_another_reader
    #   attr_reader :b_reader
    #   attr_reader :looks_like_an_attr_reader

    #   attr_writer :c_another_writer
    #   attr_writer :c_writer

    #   def alpha_sort1;                                                                end
    #   def alpha_sort2;                                                                end
    #   def destructive!;                                                               end
    #   def do_something_method;                                                        end
    #   def method_01(aaa);                                                             end
    #   def method_02(aaa, bbb = 1);                                                    end
    #   def method_03(aaa, bbb = 1, ccc = 2);                                           end
    #   def method_04(*aaa);                                                            end
    #   def method_05(aaa, bbb = 1, *ccc);                                              end
    #   def method_06(**aaa);                                                           end
    #   def method_07(aaa, *bbb, ccc: 'string1', **ddd);                                end
    #   def method_08(aaa, *bbb, **ccc, &ddd);                                          end
    #   def method_09(aaa:);                                                            end
    #   def method_10(aaa:, bbb: 1);                                                    end
    #   def method_with_every_type_of_paramater(aaa, bbb = 1, *ccc, ddd:, eee: 1, **fff, &ggg);end
    #   def questionable?;                                                              end
    #
    #   class << self
    #     def klass_complex(aaa, bbb = nil, *ccc, ddd:, eee: , **fff, &ggg);              end
    #     def klass_simple(first_param);                                                  end
    #   end
    #
    #   private
    #
    #   def keep_me_private;                                                            end
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
        @output = []
        @output.push render_start
        @indent = '  '

        render_accessors
        render_readers
        render_writers

        render_methods(@class_info.public_methods)
        render_class_methods(@class_info.class_methods)
        render_private_methods(@class_info.private_methods)

        @output.pop if @output.last == ''

        @indent = ''
        @output.push render_end

        @output.join("\n")
      end

      private

      def render_start
        "#{@indent}class #{@class_info.class_name}"
      end

      def render_accessors
        result = @class_info.accessors.map { |attr| "#{@indent}attr_accessor :#{attr.name}" }
        result.push '' unless result.length.zero?
        @output += result
      end

      def render_readers
        result = @class_info.readers.map { |attr| "#{@indent}attr_reader :#{attr.name}" }
        result.push '' unless result.length.zero?
        @output += result
      end

      def render_writers
        result = @class_info.writers.map { |attr| "#{@indent}attr_writer :#{attr.name}" }
        result.push '' unless result.length.zero?
        @output += result
      end

      def render_methods(method_list)
        result = method_list.map do |method_signature|
          render_signature = Peeky::Renderer::MethodSignatureRender.new(method_signature)
          "#{@indent}#{render_signature.render}"
        end
        result.push '' unless result.length.zero?
        @output += result
      end

      def render_class_methods(methods)
        return if methods.length.zero?

        @output += ["#{@indent}class << self"]
        @indent += '  '
        @output += render_methods(methods)
        @indent.delete_suffix!('  ')
        @output.pop if @output.last == ''
        @output += ["#{@indent}end", '']
      end

      def render_private_methods(methods)
        return if methods.length.zero?

        @output += ["#{@indent}private", '']
        @output += render_methods(methods)
      end

      def render_end
        "#{@indent}end"
      end
    end
  end
end
