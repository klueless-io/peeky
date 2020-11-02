# frozen_string_literal: true

require 'forwardable'

module Peeky
  # Method Info
  class MethodInfo
    extend Forwardable

    # List of parameters for this method
    attr_accessor :parameters

    # MethodInfo delegates to the underlying ruby method object
    attr_reader :method

    def_delegators :method, :name, :receiver, :arity, :super_method

    # Stage 2 is the method likely to be an attribute reader or writer

    # Implemented As indicates the probable representation of this
    # method in ruby, was it `def method` or `attr_reader` / `attr_writer`
    attr_reader :implementation_type

    def initialize(method, target_instance = nil)
      @method = method
      @parameters = ParameterInfo.from_method(method)
      # stage 1
      # @implementation_type = :method

      # # stage 2
      # if target_instance.nil?
      #   @implementation_type = :method
      # else
      #   infer_implementation_type(target_instance)
      # end
    end

    def debug
      puts '-' * 70
      puts name
      puts '-' * 70
      parameters.each(&:debug)
    end
  end
end
