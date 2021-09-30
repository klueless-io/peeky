# frozen_string_literal: true

require 'securerandom'

module Peeky
  module Predicates
    # Attr Reader Predicate will match true if the method info could be considered
    # a valid attr_reader
    class AttrReaderPredicate
      # Match will return true if the method_info seems to be an :attr_reader
      #
      # @param instance [Object] instance the object that has this method (required)
      # @param method_info [String] method info (required)
      def match(instance, method_info)
        return false unless prerequisites(instance, method_info)

        method_name = method_info.name

        # Refactor: Fragile
        # Really need to handle exceptions and types better
        # old_value = instance.send(method_name)

        # This code works by
        # 1. Set @name_of_method variable to random value
        # 2. Call method name and see if it returns that value
        # 3. Return match<true> if the values are equal
        new_value = SecureRandom.alphanumeric(20)
        code = <<-RUBY
          @#{method_name} = '#{new_value}' # eg. @variable = 'a3bj7a3bj7a3bj7a3bj7'
        RUBY

        cloned = instance.clone

        cloned.instance_eval(code)
        begin
          current_value = cloned.send(method_name)
        rescue StandardError #=> exception
          current_value = nil
        end

        current_value == new_value
      end

      private

      def prerequisites(instance, method_info)
        # look for obvious NON :attr_reader patterns
        return false if %w[! ? =].include?(method_info.name.to_s[-1..-1])
        return false unless method_info.parameters.length.zero?
        return false unless instance.respond_to?(method_info.name)

        true
      end
    end
  end
end
