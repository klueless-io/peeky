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

    # ruby code format when used in a signature
    attr_accessor :signature_format

    # minimal required usage in a call to the method with this paramater
    attr_accessor :minimal_call_format

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

    def debug
      puts "name                          : #{name}"
      puts "type                          : #{type}"
      puts "signature_format              : #{signature_format}"
      puts "minimal_call_format           : #{minimal_call_format}"
    end

    private

    # Convert the limited information provided by ruby method.parameters
    # to a richer structure.
    # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
    def map(param)
      @name = param.length > 1 ? param[1].to_s : ''

      case param[0]
      when :req
        @type = :param_required
        @signature_format = name.to_s
        @minimal_call_format = "'#{name}'"
      when :opt
        @type = :param_optional
        @signature_format = "#{name} = nil"
        @minimal_call_format = ''
      when :rest
        @type = :splat
        @signature_format = "*#{name}"
        @minimal_call_format = ''
      when :keyreq
        @type = :key_required
        @signature_format = "#{name}:"
        @minimal_call_format = "#{name}: '#{name}'"
      when :key
        @type = :key_optional
        @signature_format = "#{name}: nil"
        @minimal_call_format = ''
      when :keyrest
        @type = :double_splat
        @signature_format = "**#{name}"
        @minimal_call_format = ''
      when :block
        @type = :block
        @signature_format = "&#{name}"
        @minimal_call_format = ''
      else
        raise 'unknown type'
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
  end
end
