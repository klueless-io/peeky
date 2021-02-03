# frozen_string_literal: true

# require 'peeky/attr_info'

module Peeky
  # Attr Info is a container that holds read, write or read/write
  # attributes in the form of MethodInfo objects
  class AttrInfo
    # reader stores a MethodInfo for a matching reader, nil if readable style method_info not found
    attr_reader :reader
    # writer stores a MethodInfo for a matching writer, nil if writable style method_info not found
    attr_reader :writer

    def initialize(reader: nil, writer: nil)
      guard(reader, writer)

      @reader = reader
      @writer = writer
    end

    # Type of the attribute [:attr_writer, :attr_reader or :attr_accessor]
    def type
      @type ||= if @reader.nil?
                  :attr_writer
                else
                  @writer.nil? ? :attr_reader : :attr_accessor
                end
    end

    # Name of the attribute
    def name
      @name ||= @reader.nil? ? @writer.clean_name : @reader.clean_name
    end

    # Factory method that will create an AttrInfo from a list of method_infos
    #
    # There is an expectation that the list will have 1 or 2 method_infos and
    # that they will be of type :attr_reader and/or :attr_writer
    # Currently there are some edge cases that I can see where this may not
    # be true and in those cases we just ignore those cases
    def self.create(*method_infos)
      reader = method_infos.find(&:readable?)
      writer = method_infos.find(&:writable?)

      new(reader: reader, writer: writer)
    end

    private

    def guard(reader, writer)
      raise 'AttrInfo requires at least one read or write parameter' if reader.nil? && writer.nil?

      guard_reader(reader) unless reader.nil?
      guard_writer(writer) unless writer.nil?
    end

    def guard_reader(reader)
      raise 'reader: parameter must be of type MethodInfo' unless reader.is_a?(Peeky::MethodInfo)
      raise 'reader: method does not implement the :attr_reader signature' unless reader.implementation_type == :attr_reader
    end

    def guard_writer(writer)
      raise 'writer: parameter must be of type MethodInfo' unless writer.is_a?(Peeky::MethodInfo)
      raise 'writer: method does not implement the :attr_writer signature' unless writer.implementation_type == :attr_writer
    end
  end
end
