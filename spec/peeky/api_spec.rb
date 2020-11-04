# frozen_string_literal: true

require 'spec_helper'

class SampleClassForApi
  # Check that attr_* is handled
  attr_accessor :a_read_write1, :a_read_write2, :a_read_write3
  attr_reader   :b_reader, :b_another_reader
  attr_writer   :c_writer, :c_another_writer

  def do_something_method
  end

  def looks_like_an_attr_reader
    @looks_like_an_attr_reader ||= 5
  end

  # Method has
  # - required positional parameter
  def position(aaa)
  end

  # Method has
  # - required positional parameter
  # - optional positional parameter
  def position_and_optional(aaa, bbb = 1)
  end

  def position_and_optionals(aaa, bbb = 1, ccc = 2)
  end

  def optional_list(*aaa)
  end

  def required_and_optional_list(aaa, bbb, *ccc)
  end

  def named(**aaa)
  end

  def required_named_optional_list(aaa, *bbb, **ccc)
  end

  def required_named_optional_list_block(aaa, *bbb, **ccc, &ddd)
  end

  def named_(aaa:)
  end

  def n(aaa:, bbb: 1)
  end

  def p?
  end

  def q!
  end

  def z(aaa, bbb = 1, *ccc, ddd:, eee: 1, **fff, &ggg)
  end

  # Check that methods are sorted
  def alpha_sort2;                                        end
  def alpha_sort1;                                        end
end

RSpec.describe Peeky::Api do
  subject { instance }

  describe '#constructor' do
    let(:instance) { described_class.new }
    context 'with default parameters' do
      it { is_expected.not_to be_nil }
    end
  end
  describe 'Peaky#api' do
    let(:instance) { Peeky.api }

    # let(:method_signature) { Peeky::MethodInfo.new(method) }
    # let(:method) { target_instance.method(method_name) }
    # let(:method_name) { :simple }

    let(:target_instance) { SampleClassForApi.new }

    it { is_expected.not_to be_nil }

    describe '#build_class_info' do
      subject { instance.build_class_info(target_instance) }

      it { is_expected.not_to be_nil }
      it { is_expected.to be_a Peeky::ClassInfo }
    end
  end
end
