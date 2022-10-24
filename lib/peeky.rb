# frozen_string_literal: true

require 'peeky/version'

require 'peeky/api'

require 'peeky/attr_info'
require 'peeky/class_info'
require 'peeky/method_info'
require 'peeky/parameter_info'

require 'peeky/predicates/attr_reader_predicate'
require 'peeky/predicates/attr_writer_predicate'

require 'peeky/renderer/class_debug_render'
require 'peeky/renderer/class_interface_render'
require 'peeky/renderer/class_interface_yard_render'
require 'peeky/renderer/method_call_minimum_params_render'
require 'peeky/renderer/method_signature_render'
require 'peeky/renderer/method_signature_with_debug_render'

module Peeky
  class Error < StandardError; end
  # Your code goes here...
end

if ENV.fetch('KLUE_DEBUG', 'false').downcase == 'true'
  namespace = 'Peeky::Version'
  file_path = $LOADED_FEATURES.find { |f| f.include?('peeky/version') }
  version   = Peeky::VERSION.ljust(9)
  puts "#{namespace.ljust(35)} : #{version.ljust(9)} : #{file_path}"
end
