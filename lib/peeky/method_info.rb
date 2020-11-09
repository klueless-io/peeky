# frozen_string_literal: true

require 'forwardable'

module Peeky
  # Method info store a list of instance methods and attr_* for
  # a ruby class.
  class MethodInfo
    extend Forwardable

    # List of parameters for this method
    attr_accessor :parameters

    # MethodInfo delegates to the underlying ruby method object
    attr_reader :focal_method

    def_delegators :focal_method, :name, :receiver, :arity, :super_method

    # Stage 2 is the method likely to be an attribute reader or writer

    # Implementation type indicates the probable representation of this
    # method in ruby, was it `def method` or `attr_reader` / `attr_writer`
    attr_reader :implementation_type

    def initialize(method, target_instance)
      @focal_method = method
      @target_instance = target_instance
      @parameters = ParameterInfo.from_method(method)
      # stage 1
      # @implementation_type = :method

      # stage 2
      infer_implementation_type
      
      # stage 3
      infer_default_paramaters
    end

    # Stage 2 (working out) attr_accessor
    # Name of method minus writer annotations
    # Example :writable_attribute= becomes :writable_attribute
    def clean_name
      @clean_name ||= begin
        n = name.to_s
        n.end_with?('=') ? n.delete_suffix('=').to_sym : name
      end
    end

    def infer_implementation_type
      if @target_instance.nil?
        @implementation_type = :method
      elsif match(Peeky::Predicates::AttrReaderPredicate)
        @implementation_type = :attr_reader
      elsif match(Peeky::Predicates::AttrWriterPredicate)
        @implementation_type = :attr_writer
      else
        @implementation_type = :method
      end
    end

    def get_parameter(name)
      name = name.to_s
      parameters.find { |p| p.name == name }
    end

    def has_optional?
      parameters.any?(&:optional?)
    end

    # def infer_default_paramaters
    # end

    # WARNING: Unit test coverage went from .1 seconds to 30-40 seconds
    # when I first introduced this method.
    #
    # I now only call TracePoint if I have optional parameters to be inferred
    # The tests are now down to 5 seconds, but it highlights the cost of use
    # TracePoint.
    def infer_default_paramaters
      minimalist_method = Peeky::Renderer::MethodCallMinimumParamsRender.new(self).render

      return if minimalist_method.end_with?('=')
      return unless has_optional?

      trace = TracePoint.trace(:call, :c_call) do |tp|
        next unless tp.self.is_a?(@target_instance.class)
        next unless tp.method_id == self.name
    
        tp.parameters.each do |type, name|
          method_paramater = self.get_parameter(name)

          if method_paramater.optional?
            value = tp.binding.local_variable_get(name)
            method_paramater.default_value = value
          end
        end
      end

      trace.enable do
        begin
          @target_instance.instance_eval(minimalist_method)
        rescue => e
          puts e.message
          raise
        end
      end
    end

    def match(predicate)
      predicate.new.match(@target_instance, self)
    end

    def method?
      @implementation_type == :method
    end

    # https://github.com/rubyide/vscode-ruby/issues/454
    # if I prefix these methods with attr_ then will get an issue
    # in the language server.
    # Cannot read property 'namedChildren' of undefined
    def readable?
      @implementation_type == :attr_reader
    end

    def writable?
      @implementation_type == :attr_writer
    end

    def debug
      puts '-' * 70
      puts name
      puts '-' * 70
      parameters.each(&:debug)
    end
  end
end
