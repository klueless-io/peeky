# frozen_string_literal: true

module Peeky
  # Api
  class Api
    # def initialize; end

    # Build a ClassInfo structure based around a
    # ruby class instance.
    def build_class_info(instance)
      Peeky::ClassInfo.new(instance)
    end
  end
end
