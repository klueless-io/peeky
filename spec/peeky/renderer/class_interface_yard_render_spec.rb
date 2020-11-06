# frozen_string_literal: true

require 'spec_helper'

class YardSample
  # Check that attr_* is handled
  attr_accessor :a_read_write1, :a_read_write2, :a_read_write3
  attr_reader   :b_reader1, :b_reader2
  attr_writer   :c_writer1, :c_writer2

  # Check that various method signatures are handled
  # Check that various method signatures are handled
  def d_do_something_method
  end

  def e_looks_like_an_attr_reader
    @e_looks_like_an_attr_reader ||= 5
  end

  def e_method_with_required_param(first_name)
  end

  def f_method_with_required_param_and_optional_param(first_name, last_name = '')
  end

  # TODO: Need to get the type right?
  def g_method_with_required_param_and_two_optional_params(first_name, last_name = '', age = 21)
  end

  def h_list_of_optional_parameters(*command_args)
  end

  def i_method_with_two_required_params_and_list_of_optional_params(first_name, last_name, *alias_names)
  end

  def j_method_with_list_of_named_arguments(**options)
  end

  def k_method_with_block(&code_block)
  end

  def l_method_with_key_value_param_required(name:)
  end

  def n_method_with_key_value_param_required_and_optional_key_value(last_name:, salutation: 'Mr')
  end

  def p_available?
  end

  def q_danger_will_robinson!
  end

  def z_complex(aaa, bbb = 1, *ccc, ddd:, eee: 1, **fff, &ggg)
  end

  # Check that methods are sorted
  def alpha_sort2;                                        end
  def alpha_sort1;                                        end
end

RSpec.describe Peeky::Renderer::ClassInterfaceYardRender do
  subject { instance }

  let(:instance) { described_class.new(class_info) }
  let(:class_info) { Peeky::ClassInfo.new(target_instance) }
  let(:target_instance) { YardSample.new }
  let(:method_name) { :simple }

  describe '#constructor' do
    context 'with default parameters' do
      it { is_expected.not_to be_nil }
    end
  end

  describe '#render' do
    subject { instance.render }

    # it do
    #   is_expected.to start_with('class YardSample')
    #     .and(include 'attr_accessor :a')
    #     .and(include 'attr_reader :b')
    #     .and(include 'attr_writer :c')
    #     .and(include 'def e(aaa);')
    #     .and(include 'def z(aaa, bbb = nil, *ccc, ddd:, eee: nil, **fff, &ggg);')
    # end

    it do
      instance.indent = '    '
      output = instance.render

      File.write('lib/peeky/example/yard_sample.rb', <<~RUBY
        module Peeky
          module Example
        #{output}
          end
        end
      RUBY
      )
    end
  end

  describe '#debug' do
    # it { puts instance.render } # uncomment to print debug content
  end
end
