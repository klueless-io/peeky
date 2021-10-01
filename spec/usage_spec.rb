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

    private

    def keep_me_private; end
  end
end
# rubocop:enable Style/OptionalBooleanParameter

RSpec.describe 'Usage' do
  describe 'Peaky#api' do
    let(:api) { Peeky.api }

    describe '#build_class_info' do
      it 'builds class information with meta data for the target class - lazy loaded' do
        class_info = api.build_class_info(Sample::SimpleClass.new)

        puts class_info
      end

      it 'builds class information with meta data for the target class - pre-loaded' do
        class_info = api.build_class_info(Sample::ComplexClass.new, lazy: false)

        puts class_info
      end
    end

    context '#render_class' do
      it 'render class_interface with class_info' do
        class_info = api.build_class_info(Sample::SimpleClass.new)

        puts api.render_class(:class_interface, class_info: class_info)
      end

      it 'render class_interface_yard with instance of intended class' do
        puts api.render_class(:class_interface_yard, instance: Sample::SimpleClass.new)
      end
    end

    context '#render_class examples' do
      it 'render class_debug' do
        # puts api.render_class(:class_debug, instance: Sample::SimpleClass.new)
        puts api.render_class(:class_debug, instance: Sample::ComplexClass.new)
      end

      it 'render class_interface' do
        puts api.render_class(:class_interface, instance: Sample::ComplexClass.new)
      end

      fit 'render class_interface_yard' do
        puts api.render_class(:class_interface_yard, instance: Sample::ComplexClass.new)
      end
    end
  end
end
