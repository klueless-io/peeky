# frozen_string_literal: true

require 'securerandom'

module Peeky
  module Predicates
    # Attr Writer Predicate will match true if the method info could be considered
    # a valid attr_writer
    class AttrWriterPredicate
      def match(instance, method_info)
        return false unless prerequisites(instance, method_info)

        param = method_info.parameters.first
        param.type == :param_required && param.name.empty?
      end

      private

      def prerequisites(instance, method_info)
        return false if %w[! ?].include?(method_info.name.to_s[-1..-1])
        return false unless method_info.name.to_s.end_with?('=')
        return false unless instance.respond_to?(method_info.name)
        return false unless method_info.parameters.length == 1

        true
      end
    end
  end
end
