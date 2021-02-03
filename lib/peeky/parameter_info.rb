# frozen_string_literal: true

module Peeky
  # Parameter Info takes a ruby paramater pair (*see below) and maps
  # it to more readily usable properties
  #
  # Ruby parameter is an odd array format that with an array of 1 or 2 elements.
  # Examples:
  #  - [:req]
  #  - [:req, 'aaa']
  #  - [:opt, 'aaa']
  #  - [:rest, 'aaa']
  #  - [:keyreq, 'aaa']
  #  - [:key, 'aaa']
  #  - [:block, 'aaa']
  class ParameterInfo
    # name of the parameter
    attr_accessor :name

    # type of the parameter
    attr_accessor :type

    # default value for positional or keyed parameters
    attr_accessor :default_value

    def initialize(param)
      map(param)
    end

    private_class_method :new

    # Ruby parameter is an odd array format that with an array of 1 or 2 elements.
    # Examples:
    #  - [:req]
    #  - [:req, 'aaa']
    #  - [:opt, 'aaa']
    #  - [:rest, 'aaa']
    #  - [:keyreq, 'aaa']
    #  - [:key, 'aaa']
    #  - [:block, 'aaa']
    def self.from_parameter(ruby_parameter)
      new(ruby_parameter)
    end

    # Gets list of parameters fro ma ruby method and maps them to
    # an array of ParameterInfo
    def self.from_method(ruby_method)
      ruby_method.parameters.map { |ruby_paramater| from_parameter(ruby_paramater) }
    end

    # ruby code formatted for use in a method signature
    def signature_format
      @_signature_format ||= begin
        method_name = "signature_format_#{@type}".to_sym

        m = method(method_name)
        m.call
      end
    end

    # minimal required usage in a call to the method with this paramater
    def minimal_call_format
      @_minimal_call_format ||= begin
        method_name = "minimal_call_format_#{@type}".to_sym

        if respond_to?(method_name, true)
          m = method(method_name)
          m.call
        else
          minimal_call_format_ignore
        end
      end
    end

    # Optional?

    # @return [Boolean] true when parameter is one of the optional types?
    def optional?
      @_optional |= (@type == :param_optional || @type == :key_optional)
    end

    # Default value type will look at the default value and try to
    # infer the class behind it. Will default to 'Object' fi nil
    def default_value_type
      if @default_value.nil?
        'Object'
      else
        @default_value.class
      end
    end

    # Wrap default value in quotes if string, or no wrapping otherwise
    #
    # @param value_for_nil [String] value for nil, generally '' or 'nil' (required)
    def wrap_default_value(value_for_nil)
      if @default_value.is_a?(String)
        "'#{@default_value}'"
      else
        @default_value.nil? ? value_for_nil : @default_value
      end
    end

    private

    # Convert the limited information provided by ruby method.parameters
    # to a richer structure.
    # rubocop:disable Metrics/CyclomaticComplexity
    def map(param)
      @name = param.length > 1 ? param[1].to_s : ''

      @default_value = nil

      case param[0]
      when :req
        @type = :param_required
      when :opt
        @type = :param_optional
      when :rest
        @type = :splat
      when :keyreq
        @type = :key_required
      when :key
        @type = :key_optional
      when :keyrest
        @type = :double_splat
      when :block
        @type = :block
      else
        raise 'unknown type'
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    # Signature format *: Is used to format a parameter when it is used
    # inside of a method signature, eg. def my_method(p1, p2 = 'xyz', p3: :name_value)

    def signature_format_param_required
      name.to_s
    end

    def signature_format_param_optional
      "#{name} = #{wrap_default_value('nil')}" # signature format needs to be moved to a method
    end

    def signature_format_splat
      "*#{name}"
    end

    def signature_format_key_required
      "#{name}:"
    end

    def signature_format_key_optional
      "#{name}: #{wrap_default_value('')}"
    end

    def signature_format_double_splat
      "**#{name}"
    end

    def signature_format_block
      "&#{name}"
    end

    # Minimal call format *: Is used to format a call to a method with the least
    # number of parameters needed to make it work.

    def minimal_call_format_ignore
      ''
    end

    def minimal_call_format_param_required
      "'#{@name}'"
    end

    def minimal_call_format_key_required
      "#{@name}: '#{@name}'"
    end
  end
end
