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

    attr_reader :access_control

    def_delegators :focal_method, :name, :receiver, :arity, :super_method

    ## Stage 2 is the method likely to be an attribute reader or writer
    #

    # Implementation type indicates the probable representation of this
    # method in ruby, was it
    # instance method         `def method`
    # instance method reader  `attr_reader`
    # instance method writer  `attr_writer`
    # class method            `def self.method`
    attr_reader :implementation_type

    def initialize(method, target_instance, implementation_type: :method, access_control: :public)
      @focal_method = method
      @target_instance = target_instance
      @access_control = access_control
      @implementation_type = implementation_type
      @parameters = ParameterInfo.from_method(method)

      infer_implementation_type
      infer_default_paramaters
    end

    # Stage 2 (working out) attr_accessor
    #

    # Name of method minus writer annotations
    # Example
    #   :writable_attribute=
    #   # becomes
    #   :writable_attribute
    def clean_name
      @clean_name ||= begin
        n = name.to_s
        n.end_with?('=') ? n.delete_suffix('=').to_sym : name
      end
    end

    # Infer implementation type [:class_method, :method, :attr_reader or :attr_writer]
    def infer_implementation_type
      return unless @implementation_type == :method

      @implementation_type = :attr_reader if match(Peeky::Predicates::AttrReaderPredicate)
      @implementation_type = :attr_writer if match(Peeky::Predicates::AttrWriterPredicate)
    end

    # Get parameter by name
    #
    # @param name [String] name (required)
    def get_parameter(name)
      name = name.to_s
      parameters.find { |p| p.name == name }
    end

    # Has any optional paramaters?

    # @return [Boolean] true when any parameter is optional?
    def optional?
      parameters.any?(&:optional?)
    end

    # Infer default paramater values
    #
    # WARNING: Unit test coverage went from .1 seconds to 30-40 seconds
    # when I first introduced this method.
    #
    # I now only call TracePoint if I have optional parameters to be inferred.
    #
    # The tests are now down to 5 seconds, but it highlights the cost of use
    # TracePoint.
    def infer_default_paramaters
      class_name = @implementation_type == :class_method ? @target_instance.class.name : nil
      minimalist_method = Peeky::Renderer::MethodCallMinimumParamsRender.new(self, class_name: class_name).render

      return if minimalist_method.end_with?('=')
      return unless optional?

      tracer.enable do
        # TODO: minimalist method should be able to handle class methods
        @target_instance.instance_eval(minimalist_method)       if @implementation_type == :method
        @target_instance.class.instance_eval(minimalist_method) if @implementation_type == :class_method
      rescue StandardError => e
        # just print the error for now, we are only attempting to capture the
        # first call, any errors inside the call cannot be dealt with and should
        # not be re-raised
        puts e.message
      end
    end

    def tracer
      TracePoint.trace(:call, :c_call) do |tp|
        next unless tp.self.is_a?(@target_instance.class)
        next unless tp.method_id == name

        tp.parameters.each do |_type, param_name|
          method_paramater = get_parameter(param_name)

          if method_paramater.optional?
            value = tp.binding.local_variable_get(param_name)
            method_paramater.default_value = value
          end
        end
      end
    end

    # Match
    #
    # @param predicate [String] use a predicate object with the signature match(instance, method_info)
    def match(predicate)
      predicate.new.match(@target_instance, self)
    end

    # Method?

    # @return [Boolean] true when implementation type is method?
    def method?
      @implementation_type == :method
    end

    # Readable?
    #
    # @return [Boolean] true when readable?
    def readable?
      # Method naming issue: VSCode Ruby Language Server
      #
      # If this method is renamed to attr_readable, same for attr_writable.
      #
      # https://github.com/rubyide/vscode-ruby/issues/454
      # if I prefix these methods with attr_ then will get an issue
      # in the language server.
      #
      # Cannot read property 'namedChildren' of undefined

      @implementation_type == :attr_reader
    end

    # Writable?

    # @return [Boolean] true when implementation_type writable?
    def writable?
      @implementation_type == :attr_writer
    end
  end
end
