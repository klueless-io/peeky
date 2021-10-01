# frozen_string_literal: true

require 'active_support/core_ext/string'

module Peeky
  module Renderer
    # Render: Class Interface with YARD documentation
    class ClassInterfaceYardRender
      # Indentation prefix as a string, defaults to +''+
      #
      # If you were writing a class into a file with an existing
      # module, you may set the indent to +'  '+ if you wanted this
      # render to indent by two spaces
      attr_accessor :indent

      # Default param type when documenting positional and named parameters.
      # Defaults to  <String>
      attr_accessor :default_param_type

      # Default param type when documenting splat *parameters.
      # Defaults to  <Object>
      attr_accessor :default_splat_param_type

      # ClassInfo with information about the class instance to be rendered.
      attr_reader :class_info

      def initialize(class_info)
        @class_info = class_info
        @indent = ''
        @default_param_type = 'String'
        @default_splat_param_type = 'Object'
      end

      # Render the class interface with YARD documentation
      def render
        output = []
        output.push render_start
        @indent += '  '
        output += (render_accessors + render_readers + render_writers + render_methods)
        output.pop if output.last == ''

        @indent = @indent[0..-3]

        output.push render_end

        output.join("\n")
      end

      private

      def render_start
        [
          "#{@indent}# #{@class_info.class_name.titleize.humanize}",
          "#{@indent}class #{@class_info.class_name}"
        ]
      end

      def render_accessors
        result = []
        @class_info.accessors.map.with_index do |attr, index|
          result.push '' if index.positive?
          result.push "#{@indent}# #{attr.name.to_s.humanize}"
          result.push "#{@indent}attr_accessor :#{attr.name}"
        end
        result.push '' unless result.length.zero?
        result
      end

      def render_readers
        result = []
        @class_info.readers.map.with_index do |attr, index|
          result.push '' if index.positive?
          result.push "#{@indent}# #{attr.name.to_s.humanize}"
          result.push "#{@indent}attr_reader :#{attr.name}"
        end
        result.push '' unless result.length.zero?
        result
      end

      def render_writers
        result = []
        class_info.writers.map.with_index do |attr, index|
          result.push '' if index.positive?
          result.push "#{@indent}# #{attr.name.to_s.humanize}"
          result.push "#{@indent}attr_writer :#{attr.name}"
        end
        result.push '' unless result.length.zero?
        result
      end

      # rubocop:disable Metics/AbcSize
      def render_methods
        result = []
        class_info.public_methods.map.with_index do |method_signature, index|
          render_method(result, method_signature, index)
        end
        class_info.private_methods.map.with_index do |method_signature, index|
          result.push "\n#{indent}private\n" if index.zero?
          render_method(result, method_signature, index)
        end
        result.push '' unless result.length.zero?
        result
      end
      # rubocop:enable Metics/AbcSize

      # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
      def render_method(result, method_signature, index)
        result.push '' if index.positive?
        result.push "#{@indent}# #{method_signature.name.to_s.humanize}"

        method_signature.parameters.each_with_index do |parameter, param_index|
          result.push "#{@indent}#" if param_index.zero?

          case parameter.type
          when :splat
            result.push "#{@indent}# @param #{parameter.name} [Array<#{default_splat_param_type}>] *#{parameter.name} - list of #{parameter.name.to_s.humanize.downcase}"
          when :double_splat
            result.push "#{@indent}# @param #{parameter.name} [<key: value>...] **#{parameter.name} - list of key/values"
          when :block
            result.push "#{@indent}# @param #{parameter.name} [Block] &#{parameter.name}"
          when :key_required
            result.push "#{@indent}# @param #{parameter.name} [#{default_param_type}] #{parameter.name}: <value for #{parameter.name.to_s.humanize.downcase}> (required)"
          when :key_optional
            result.push "#{@indent}# @param #{parameter.name} [#{parameter.default_value_type}] #{parameter.name}: is optional, defaults to #{parameter.wrap_default_value('nil')}"
          when :param_required
            result.push "#{@indent}# @param #{parameter.name} [#{default_param_type}] #{parameter.name.to_s.humanize.downcase} (required)"
          when :param_optional
            result.push "#{@indent}# @param #{parameter.name} [#{parameter.default_value_type}] #{parameter.name} is optional, defaults to #{parameter.wrap_default_value('nil')}"
            # result.push "#{@indent}# @param #{parameter.name} [#{default_param_type}] #{parameter.name.to_s.humanize.downcase} (optional)"
          else
            result.push "#{@indent}# @param #{parameter.name} [#{default_param_type}] #{parameter.name.to_s.humanize.downcase}"
          end
        end

        if method_signature.name.to_s.end_with?('?')
          result.push ''
          result.push "#{@indent}# @return [Boolean] true when #{method_signature.name.to_s.humanize.downcase}"
        end

        render_signature = Peeky::Renderer::MethodSignatureRender.new(method_signature)
        render_signature.indent = @indent
        render_signature.style = :default
        result.push render_signature.render
      end
      # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength

      def render_end
        "#{@indent}end"
      end
    end
  end
end
