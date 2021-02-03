# frozen_string_literal: true

# Peeky module provides access to the API via the
# module method Peeky.api
module Peeky
  class << self
    attr_accessor :api
  end

  # API has factory and creational patterns for easy usage
  # of the Peeky reflection system
  class Api
    # Build a {Peeky::ClassInfo} structure based around a
    # ruby class instance.
    #
    # ClassInfo stores information about the instance of a
    # class that is passed in including methods, attr_accessors
    # attr_readers and attr_writers.
    #
    # @param instance [Object] instance of class to gather information about (required)
    # @param lazy [TrueClass] lazy load method and parameter information, laze: is optional, defaults to true
    def build_class_info(instance, lazy: true)
      ci = Peeky::ClassInfo.new(instance)
      ci.load unless lazy
      ci
    end

    # Render a class using a predefined class renderer
    #
    # ^1: One of class_info and instance must supplied, they are mutually
    # exclusive to each other.
    #
    # @param render_key [Symbol] class render key (required)
    # @param class_info [Object] class_info: is optional^1, defaults to nil
    # @param instance [Object] instance: is optional^1, defaults to nil
    # @param _opts [<key: value>...] **_opts - list of key/values that can help configure render
    def render_class(render_key, class_info: nil, instance: nil, **_opts)
      raise 'Call render_class with class_info OR instance.' if class_info.nil? && instance.nil?
      raise 'Call render_class with class_info OR instance, these parameters are mutually exclusive' if !class_info.nil? && !instance.nil?

      renderer = class_renderer(render_key)

      class_info = Peeky::ClassInfo.new(instance) if class_info.nil?

      renderer.new(class_info).render
    end

    # Get a method renderer by :key
    #
    # TODO: Refactor to a configurable system
    # @param key [String] key is a shortcut to a specific Peeky::Render that handles method_info (required)
    def method_renderer(key)
      case key
      when :signature
        Peeky::Renderer::MethodSignatureRender
      when :signature_with_debug
        Peeky::Renderer::MethodSignatureWithDebugRender
      when :call_minimum_params
        Peeky::Renderer::MethodCallMinimumParamsRender
      else
        raise "Unknown method renderer: #{key}"
      end
    end

    # Get a class renderer by :key
    #
    # TODO: Refactor to a configurable system
    # @param key [String] key is a shortcut to a specific Peeky::Renderer that handles class_info (required)
    def class_renderer(key)
      case key
      when :class_debug
        Peeky::Renderer::ClassDebugRender
      when :class_interface
        Peeky::Renderer::ClassInterfaceRender
      when :class_interface_yard
        Peeky::Renderer::ClassInterfaceYardRender
      else
        raise "Unknown class renderer: #{key}"
      end
    end

    # def render_method()
    # end
  end
end

Peeky.api = Peeky::Api.new
