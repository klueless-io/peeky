# frozen_string_literal: true

require 'peeky/version'

require 'peeky/attr_info'
require 'peeky/class_info'
require 'peeky/method_info'
require 'peeky/parameter_info'

require 'peeky/predicates/attr_reader_predicate'
require 'peeky/predicates/attr_writer_predicate'

require 'peeky/renderer/method_call_minimum_params_renderer'

module Peeky
  class Error < StandardError; end
  # Your code goes here...
end
