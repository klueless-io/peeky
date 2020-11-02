# frozen_string_literal: true

require 'securerandom'

module Peeky
  module Predicates
    # Attr Reader Predicate will match true if the method info could be considered
    # a valid attr_reader
    class AttrReaderPredicate
      def match(instance, method_info)
        return false unless prerequisites(instance, method_info)

        variable_name = "@#{method_info.name}"
        method_name = method_info.name

        # Refactor: Fragile
        # Really need to handle exceptions and types better
        # old_value = instance.send(method_name)
        new_value = SecureRandom.alphanumeric(20)
        code = <<-RUBY
          #{variable_name} = '#{new_value}' # @variable = 'a3bj7a3bj7a3bj7a3bj7'
        RUBY
        instance.instance_eval(code)
        current_value = instance.send(method_name)
        current_value == new_value
      end

      private

      def prerequisites(instance, method_info)
        return false if %w[! ? =].include?(method_info.name.to_s[-1..-1])
        return false unless method_info.parameters.length.zero?
        return false unless instance.respond_to?(method_info.name)

        true
      end
    end
  end
end
