# frozen_string_literal: true

module Peeky
  # Class Info stores information about the class instance that is provided.
  #
  # The information is collected into MethodInfo objects
  # that live within the signatures accessor.
  #
  # This information is then separated out into
  # :methods, :attr_accessors, :attr_readers and :attr_writers
  class ClassInfo
    # Holds an instance to the class you are gathering information from
    attr_reader :instance

    # Peak into class information
    def initialize(instance)
      @instance = instance
    end

    def to_s
      class_full_name
    end

    # Load class_info
    #
    # Accessing information about methods and parameters is currently
    # lazy-loaded via memoization.
    #
    # At times during debug or other edge cases, it may be useful to
    # pre-load this information early.
    def load
      ruby_instance_methods
      ruby_instance_method_names
      signatures
    end

    # Class full name includes the module namespace
    def class_full_name
      instance.class.name
    end

    # Class name
    def class_name
      @_class_name ||= class_full_name.to_s.gsub(/^.*::/, '')
      # instance.class.name.split('::').last
    end

    # Module name
    def module_name
      @_module_name ||= class_full_name.to_s.gsub(/(.*)::.*/, '\1')
    end

    # Get a list of :attr_accessor on the class
    # @return [Array<AttrInfo>] list of AttrInfo where type is :attr_accessor
    def accessors
      @_accessors ||= attribute_infos.select { |attribute_info| attribute_info.type == :attr_accessor }
    end

    # Get a list of :attr_accessors ordered the way they are in the source code
    # @return [Array<AttrInfo>] list of AttrInfo where type is :attr_accessor
    def accessors_source_order
      # TODO: This feature is required
      # May be best to have a sort object that can be created for each type of ordering that is needed
      accessors
    end

    # Attribute infos
    def attribute_infos
      @_attribute_infos ||= begin
        grouped_method_infos = signatures.select { |signature| signature.readable? || signature.writable? }.group_by(&:clean_name)

        grouped_method_infos.keys.map { |key| AttrInfo.create(*grouped_method_infos[key]) }
      end
    end

    # Method by name
    #
    # @param name [String] name (required)
    def method_by_name(name)
      signatures_by_name(name, filter_type: :method).first
    end

    # Get a list methods
    # @return [Array<MethodInfo>] list of MethodInfo where type is :method
    def methods
      @_methods ||= signatures.select { |signature| signature.implementation_type == :method }
    end

    # Get a list methods ordered the way they are in the source code
    # @return [Array<MethodInfo>] list of MethodInfo
    def methods_source_order
      # TODO: This feature is required
      # May be best to have a sort object that can be created for each type of ordering that is needed
      methods
    end

    # Reader by name
    #
    # @param name [String] name (required)
    def reader_by_name(name)
      signatures_by_name(name, filter_type: :attr_reader).first
    end

    # Get a list of :attr_reader on the class
    # @return [Array<AttrInfo>] list of AttrInfo where type is :attr_accessor
    def readers
      @_readers ||= attribute_infos.select { |attribute_info| attribute_info.type == :attr_reader }
    end

    # Get a list of :attr_reader ordered the way they are in the source code
    # @return [Array<AttrInfo>] list of AttrInfo where type is :attr_reader
    def readers_source_order
      # TODO: This feature is required
      # May be best to have a sort object that can be created for each type of ordering that is needed
      readers
    end

    # Get a list of :attr_writer on the class
    # @return [Array<AttrInfo>] list of AttrInfo where type is :attr_writer
    def writers
      @_writers ||= attribute_infos.select { |attribute_info| attribute_info.type == :attr_writer }
    end

    # Get a list of :attr_writer ordered the way they are in the source code
    # @return [Array<AttrInfo>] list of AttrInfo where type is :attr_writer
    def writers_source_order
      # TODO: This feature is required
      # May be best to have a sort object that can be created for each type of ordering that is needed
      writers
    end

    # Writer by name
    #
    # @param name [String] name (required)
    def writer_by_name(name)
      signatures_by_name(name, filter_type: :attr_writer).first
    end

    # def signatures(types = [:instance])
    # REFACT: Support different types
    #         such as static, private vs public
    #         deep, deep_to_level, this_instance.
    def signatures
      @_signatures ||= ruby_instance_methods.map { |im| MethodInfo.new(im, @instance) }
    end

    # Signatures by clean name
    #
    # @param clean_name [String] clean name (required)
    def signatures_by_clean_name(clean_name)
      signatures.select { |im| im.clean_name == clean_name }
    end

    # Signatures by name
    #
    # @param name [String] name (required)
    # @param filter_type [String] filter_type: <value for filter type> (optional)
    def signatures_by_name(name, filter_type: :all)
      return signatures.select { |im| im.name == name } if filter_type == :all

      signatures.select { |im| im.name == name && im.implementation_type == filter_type }
    end

    # Debug
    #
    # Refact: PATTERN: Come up it an debug inclusion system so that
    # so that debug helpers can be included for development and excluded
    # for production
    # @param format [String] format: <value for format> (optional)
    def debug(format: [:signatures])
      debug_method_names if format.include?(:method_names)

      return unless format.include?(:signatures)

      puts '-' * 70
      puts 'Methods'
      puts '-' * 70
      signatures.each(&:debug)
    end

    def debug_method_names
      puts '-' * 70
      puts 'Method Names'
      puts '-' * 70
      ruby_instance_method_names.each do |method_name|
        puts method_name
      end
    end

    private

    def ruby_instance_method_names
      @_ruby_instance_method_names ||= instance.class.instance_methods(false).sort
    end

    def ruby_instance_methods
      @_ruby_instance_methods ||= ruby_instance_method_names.map { |method_name| instance.method(method_name) }
    rescue StandardError => e
      puts e
    end
  end
end
