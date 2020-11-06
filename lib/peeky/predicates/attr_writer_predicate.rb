# frozen_string_literal: true

require 'securerandom'

module Peeky
  module Predicates
    # Attr Writer Predicate will match true if the method info could be considered
    # a valid attr_writer
    class AttrWriterPredicate
      # Match will return true if the method_info seems to be an :attr_writer
      #
      # @param instance [Object] instance the object that has this method (required)
      # @param method_info [String] method info (required)
      def match(instance, method_info)
        return false unless prerequisites(instance, method_info)

        param = method_info.parameters.first
        # Taking advantage of an odd reflection concept in ruby where by
        # method.parameters returns this array value [:req] for :attr_writer
        # while ordinary methods return [:req, some_param_name]
        param.type == :param_required && param.name.empty?
      end

      private

      def prerequisites(instance, method_info)
        # look for obvious NON :attr_writer patterns
        return false if %w[! ?].include?(method_info.name.to_s[-1..-1])
        return false unless method_info.name.to_s.end_with?('=')
        return false unless instance.respond_to?(method_info.name)
        return false unless method_info.parameters.length == 1

        true
      end
    end
  end
end
