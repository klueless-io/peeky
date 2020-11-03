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

      # stage 2
      @implementation_type = infer_implementation_type(target_instance)
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

    def infer_implementation_type(target_instance)
      if target_instance.nil?
        :method
      elsif match(target_instance, Peeky::Predicates::AttrReaderPredicate)
        :attr_reader
      elsif match(target_instance, Peeky::Predicates::AttrWriterPredicate)
        :attr_writer
      else
        :method
      end
    end

    def match(target_instance, predicate)
      predicate.new.match(target_instance, self)
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
