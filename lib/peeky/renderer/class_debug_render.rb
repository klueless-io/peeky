# frozen_string_literal: true

module Peeky
  module Renderer
    # Class Debug Render
    class ClassDebugRender
      attr_reader :class_info

      def initialize(class_info)
        @key_width = 30
        @class_info = class_info
      end

      # Render the class interface
      # rubocop:disable Metrics/AbcSize
      def render
        output = []
        output.push class_details
        attributes = render_accessors + render_readers + render_writers

        if attributes.length.positive?
          output.push("-- Attributes #{'-' * 86}")
          output.push(*attributes)
          output.push('')
        end

        methods = render_methods(@class_info.public_methods)

        if methods.length.positive?
          output.push("-- Public Methods #{'-' * 82}")
          output.push(*methods)
          output.push('')
        end

        methods = render_methods(@class_info.private_methods)

        if methods.length.positive?
          output.push("-- Private Methods #{'-' * 82}")
          output.push(*methods)
          output.push('')
        end

        output.pop if output.last == ''

        output.join("\n")
      end
      # rubocop:enable Metrics/AbcSize

      private

      def lj(value, size = 24)
        value.to_s.ljust(size)
      end

      def kv(key, value)
        "#{key.to_s.ljust(@key_width)}: #{value}"
      end

      def class_details
        [
          '-' * 100,
          kv('class name', @class_info.class_name),
          kv('module name', @class_info.module_name),
          kv('class full name', @class_info.class_full_name),
          ''
        ]
      end

      def render_accessors
        @class_info.accessors.map { |attr| kv('attr_accessor', attr.name) }
      end

      def render_readers
        @class_info.readers.map { |attr| kv('attr_reader', attr.name) }
      end

      def render_writers
        @class_info.writers.map { |attr| kv('attr_writer', attr.name) }
      end

      def render_methods(method_list)
        method_list.flat_map do |method|
          [
            "[ #{method.name} ]",
            *render_paramaters(method.parameters),
            ''
          ]
        end
      end

      def render_paramaters(parameters)
        result = [
          "#{lj('name')} #{lj('param format')} #{lj('type')} #{lj('default')}",
          '-' * 100
        ]

        result + parameters.map do |param|
          "#{lj(param.name)} #{lj(param.signature_format)} #{lj(param.type)} #{lj(param.default_value)}"
        end
      end
    end
  end
end
