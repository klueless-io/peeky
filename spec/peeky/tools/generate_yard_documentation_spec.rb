# frozen_string_literal: true

require 'spec_helper'

require 'peeky/tools/generate_yard_documentation'

class SampleForGenerateYardDocumentation
  attr_accessor :sample_read_write
  def sample_method
  end
end

# This is an internal tool that I use to help me document my classes
RSpec.describe Peeky::Tools::GenerateYardDocumentation do

  def files_to_document
    files = Dir['**/*.rb']
    files.reject { |f| f.include?('spec') || f.include?('example') }
  end

  # context 'select files to document' do
  #   xit 'will list the files that should be documented' do
  #     puts '-' * 70
  #     puts files_to_document
  #     puts '-' * 70
  #   end

  #   xit 'will open the files that should be documented in VSCode' do
  #     system "code #{files_to_document.join(' ')}"
  #   end
  # end

  context 'render sample classes with yard documentation' do
    let(:sample) { SampleForGenerateYardDocumentation.new }

    let(:focal_method) { sample.method(:sample_read_write) }

    let(:parameter_info) { Peeky::ParameterInfo.from_parameter([:req, 'aaa']) }
    let(:method_info) { Peeky::MethodInfo.new(focal_method, sample) }
    let(:attr_info) { Peeky::AttrInfo.new(reader: method_info) }
    let(:class_info) { Peeky::ClassInfo.new(sample) }

    let(:attr_reader_predicate) { Peeky::Predicates::AttrReaderPredicate.new }
    let(:attr_writer_predicate) { Peeky::Predicates::AttrWriterPredicate.new }

    let(:class_interface) { Peeky::Renderer::ClassInterfaceRender.new(class_info) }
    let(:class_interface_yard) { Peeky::Renderer::ClassInterfaceYardRender.new(class_info) }
    let(:method_signature) { Peeky::Renderer::MethodSignatureRender.new(method_info) }
    let(:method_signature_with_debug) { Peeky::Renderer::MethodSignatureWithDebugRender.new(method_info) }
    let(:method_call_minimum_params_render) { Peeky::Renderer::MethodCallMinimumParamsRender.new(method_info) }

    let(:api) { Peeky::Api.new }

    describe '#action' do
      let(:action) { [:xconsole, :temp_file, :compare] } # :console, :temp_file, :compare

      it '#render_class_action action' do
        # Models
        # render_class_action action, attr_info                            , 'lib/peeky/attr_info.rb'
        # render_class_action action, method_info                          , 'lib/peeky/method_info.rb'
        # render_class_action action, class_info                           , 'lib/peeky/class_info.rb'
        # render_class_action action, parameter_info                       , 'lib/peeky/parameter_info.rb'

        # # Predicates
        # render_class_action action, attr_reader_predicate                , 'lib/peeky/predicates/attr_reader_predicate.rb'
        # render_class_action action, attr_writer_predicate                , 'lib/peeky/predicates/attr_writer_predicate.rb'

        # # API
        # render_class_action action, api                                  , 'lib/peeky/api.rb'

        # # Renderers
        # render_class_action action, class_interface                      , 'lib/peeky/renderer/class_interface_render.rb'
        # render_class_action action, class_interface_yard                 , 'lib/peeky/renderer/class_interface_yard_render.rb'
        # render_class_action action, method_signature                     , 'lib/peeky/renderer/method_signature_render.rb'
        # render_class_action action, method_signature_with_debug          , 'lib/peeky/renderer/method_signature_with_debug_render.rb'
        # render_class_action action, method_call_minimum_params_render    , 'lib/peeky/renderer/method_call_minimum_params_render.rb'
      end
    end
  end

  def render_class_action(actions, instance, file)
    render_class_to_console(instance, file) if actions.include?(:console)
    if actions.include?(:temp_file)
      temp_file = render_class_to_temp_file(instance, file)
      puts temp_file
      compare_files(file, temp_file) if actions.include?(:compare)
    end
  end

  def render_class_to_console(instance, file)
    puts '-' * 70
    puts Peeky.api.render_class(:class_interface_yard, instance: instance)
    puts '-' * 70
    puts file
    puts '-' * 70
  end

  def render_class_to_temp_file(instance, existing_file)
    output = Peeky.api.render_class(:class_interface_yard, instance: instance)
    file_name = existing_file.to_s.gsub("/","-")
    file_ext = File.extname(existing_file.to_s)
    file = Tempfile.new([file_name, file_ext])
    file.write(output)
    file.close
    file.path
  end

  def compare_files(file, temp_file)
    # file = File.join('/Users/davidcruwys/dev/kgems/peeky', file)

    puts "XF: #{file}"
    puts "XE: #{File.exist?(file)}"
    puts "YF: #{temp_file}"
    puts "YE: #{File.exist?(temp_file)}"
    puts "cat #{file}"
    puts "cat #{temp_file}"
    # puts "code -d #{file} #{temp_file}"
    # puts "code #{file}"
    # puts "code #{temp_file}"
    system("code #{file} -d #{file} #{temp_file}")
    system("code #{file} -r")
    sleep 3
  end

end
