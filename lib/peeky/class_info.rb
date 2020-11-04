# frozen_string_literal: true

module Peeky
  # Class Info stores information about the
  # class instance that you pass in.
  #
  # The information is collected into MethodInfo objects
  # that live within the signatures accessor.
  #
  # This information is then separated out into
  # :methods, :attr_accessors, :attr_readers and :attr_writers
  class ClassInfo
    attr_reader :instance

    # Peak into class information
    def initialize(instance)
      @instance = instance
    end

    def class_name
      instance.class.name
    end

    def accessors
      @accessors ||= attribute_infos.select { |attribute_info| attribute_info.type == :attr_accessor }
    end

    def readers
      @readers ||= attribute_infos.select { |attribute_info| attribute_info.type == :attr_reader }
    end

    def reader_by_name(name)
      signatures_by_name(name, filter_type: :attr_reader).first
    end

    def writers
      @writers ||= attribute_infos.select { |attribute_info| attribute_info.type == :attr_writer }
    end

    def writer_by_name(name)
      signatures_by_name(name, filter_type: :attr_writer).first
    end

    def methods
      @methods ||= signatures.select { |signature| signature.implementation_type == :method }
    end

    def method_by_name(name)
      signatures_by_name(name, filter_type: :method).first
    end

    # def signatures(types = [:instance])
    # REFACT: Support different types
    #         such as static, private vs public
    #         deep, deep_to_level, this_instance.
    def signatures
      @signatures ||= ruby_instance_methods.map { |im| MethodInfo.new(im, @instance) }
    end

    def signatures_by_name(name, filter_type: :all)
      return signatures.select { |im| im.name == name } if filter_type == :all

      signatures.select { |im| im.name == name && im.implementation_type == filter_type }
    end

    def signatures_by_clean_name(clean_name)
      signatures.select { |im| im.clean_name == clean_name }
    end

    def attribute_infos
      @attribute_infos ||= begin
        grouped_method_infos = signatures.select { |signature| signature.readable? || signature.writable? }.group_by(&:clean_name)

        grouped_method_infos.keys.map { |key| AttrInfo.create(*grouped_method_infos[key]) }
      end
    end

    def debug(format: [:signatures])
      if format == :method_names
        puts '-' * 70
        puts 'Method Names'
        puts '-' * 70
        ruby_instance_method_names.each do |method_name|
          puts method_name
        end
      end

      return unless format == :signatures

      puts '-' * 70
      puts 'Methods'
      puts '-' * 70
      signatures.each(&:debug)
    end

    private

    def ruby_instance_method_names
      @ruby_instance_method_names ||= instance.class.instance_methods(false).sort
    end

    def ruby_instance_methods
      @ruby_instance_methods ||= ruby_instance_method_names.map { |method_name| instance.method(method_name) }
    end
  end
end
