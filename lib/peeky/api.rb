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
    def build_class_info(instance)
      Peeky::ClassInfo.new(instance)
    end
  end
end

Peeky.api = Peeky::Api.new
