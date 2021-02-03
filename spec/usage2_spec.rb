# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Style/OptionalBooleanParameter
module Sample
  class SimpleClass
    attr_accessor :read_write

    def position_and_optional(aaa, bbb = 1)
    end

    def optional_styles(aaa, bbb = 123, ccc = 'abc', ddd = true, eee = false, fff: 123, ggg: 'xyz', hhh: true, iii: false)
    end
  end

  class ComplexClass
    attr_accessor :a_read_write1, :a_read_write2
    attr_reader   :b_reader, :b_another_reader
    attr_writer   :c_writer, :c_another_writer

    def do_something_method
    end

    def looks_like_an_attr_reader
      @looks_like_an_attr_reader ||= 5
    end

    def method_01(aaa); end

    def method_02(aaa, bbb = 1); end

    def method_03(aaa, bbb = 1, ccc = 2); end

    def method_04(*aaa); end

    def method_05(aaa, bbb = 1, *ccc); end

    def method_06(**aaa); end

    def method_07(aaa, *bbb, ccc: 'string1', **ddd); end

    def method_08(aaa, *bbb, **ccc, &ddd); end

    def method_09(aaa:); end

    def method_10(aaa:, bbb: 1); end

    def questionable?; end

    def destructive!; end

    def method_with_every_type_of_paramater(aaa, bbb = 1, *ccc, ddd:, eee: 1, **fff, &ggg); end

    # Check that methods are sorted
    def alpha_sort2;                                        end
    def alpha_sort1;                                        end
  end
end
# rubocop:enable Style/OptionalBooleanParameter

nop = Proc.new do
  # 
end

RSpec.describe 'Usage2',
               :usecases,
               :jsonX,
               :debugX,
               :markdown,
               :markdown_prettier,
               :markdown_openX,
               markdown_file: 'USAGE2.md',
               document_title: 'Peeky',
               document_description: "This document will show you how to use Peeky.\n\nPeeky is a Ruby GEM for peaking into ruby classes and extracting meta" do

#   usecase '',
#           title: 'Usage',
#           usage: 'Sample Classes',
#           usage_description: 'The usage examples listed below will work with these sample classes' do

#     ruby('Simple example',
#           source_override: uc_file_content('spec/usage2_spec.rb', lines: [*(6..15), (59)]),
#           &nop)

#     ruby('Complex example',
#       source_override: uc_file_content('spec/usage2_spec.rb', lines: [*(17..59)]),
#       &nop)
#   end

#   usecase '',
#           title: 'Build Class Information',
#           summary: 'Use build_class_info to extract meta data from a ruby class' do
  
#     ruby 'Build ClassInfo - lazy', summary: 'By default information is lazy loaded only when accessed' do
#       class_info = Peeky.api.build_class_info(Sample::SimpleClass.new)

#       puts class_info
#     end

#     code 'Console output', code_type: :text, summary: '' do
# =begin
#   class                    : Sample::SimpleClass
#   # of instance methods    :
#   # of accessors           :
#   # of readers             :
#   # of writers             :
#   # of methods             :
# =end
#     end

#     ruby 'Build ClassInfo - pre-loaded', summary: 'Pre-load will ensure that methods and parameters are loaded straight away.' do
#       class_info = Peeky.api.build_class_info(Sample::SimpleClass.new, lazy: false)

#       puts class_info
#     end

#     code 'Console output', code_type: :text, summary: '' do
# =begin
#     class                    : Sample::SimpleClass
#     # of instance methods    : optional_styles, position_and_optional, read_write, read_write=
#     # of accessors           : 1
#     # of readers             : 0
#     # of writers             : 0
#     # of methods             : 2
# =end
#     end

    code '' do |x|
      puts '-' * 150
      puts x.class
      puts x.inspect
      puts x.class.instance_methods(false)
      puts x.metadata
      puts '-' * 150
    end
      
  # end
end
