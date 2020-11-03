# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/ParameterLists
class SampleClassClassInfoSpec
  attr_accessor :a # produces two signatures
  attr_reader   :b
  attr_writer   :c

  def d; end

  def simple(first_param); end

  def complex(aaa, bbb = 1, *ccc, ddd:, eee: 1, **fff, &ggg); end
end
# rubocop:enable Metrics/ParameterLists

RSpec.describe Peeky::ClassInfo do
  subject { instance }

  let(:instance) { described_class.new(target_instance) }
  let(:target_instance) { SampleClassClassInfoSpec.new }

  describe '#constructor' do
    context 'with default parameters' do
      it { is_expected.not_to be_nil }

      it { is_expected.to have_attributes(class_name: 'SampleClassClassInfoSpec') }
    end
  end

  describe '#methods' do
    subject { instance.methods }

    it { is_expected.to have_attributes(length: 3) }
  end

  describe '#signatures' do
    subject { instance.signatures }

    it { is_expected.to have_attributes(length: 7) }
  end

  describe '#attribute_infos' do
    subject { instance.attribute_infos }

    it { is_expected.to have_attributes(length: 3) }

    describe '#accessors' do
      subject { instance.accessors }

      it { is_expected.to have_attributes(length: 1) }
      it do
        is_expected.to include(
          have_attributes(
            type: :attr_accessor,
            reader: be_a(Peeky::MethodInfo).and(be_readable),
            writer: be_a(Peeky::MethodInfo).and(be_writable)
          )
        )
      end
    end

    describe '#readers' do
      subject { instance.readers }

      it { is_expected.to have_attributes(length: 1) }
      it do
        is_expected.to include(
          have_attributes(
            type: :attr_reader,
            reader: be_a(Peeky::MethodInfo).and(be_readable),
            writer: be_nil
          )
        )
      end
    end

    describe '#writers' do
      subject { instance.writers }

      it { is_expected.to have_attributes(length: 1) }
      it do
        is_expected.to include(
          have_attributes(
            type: :attr_writer,
            reader: be_nil,
            writer: be_a(Peeky::MethodInfo).and(be_writable)
          )
        )
      end
    end
  end

  describe '#signatures_by_name' do
    subject { instance.signatures_by_name(name) }

    context 'when simple method' do
      let(:name) { :simple }

      it { is_expected.to have_attributes(length: 1) }
      it { is_expected.to include(have_attributes(name: :simple, implementation_type: :method)) }
    end

    context 'when attribute reader method' do
      let(:name) { :a }

      it { is_expected.to have_attributes(length: 1) }
      it { is_expected.to include(have_attributes(name: :a, implementation_type: :attr_reader)) }
    end

    context 'when attribute writer method' do
      let(:name) { :a= }

      it { is_expected.to have_attributes(length: 1) }
      it { is_expected.to include(have_attributes(name: :a=, implementation_type: :attr_writer)) }
    end
  end

  describe '#signatures_by_clean_name' do
    subject { instance.signatures_by_clean_name(clean_name) }

    context 'when simple method' do
      let(:clean_name) { :simple }

      it { is_expected.to have_attributes(length: 1) }
      it { is_expected.to include(have_attributes(clean_name: :simple)) }
    end

    context 'when attribute accessible (reader & writer) method' do
      let(:clean_name) { :a }

      it { is_expected.to have_attributes(length: 2) }
      it do
        is_expected.to include(
          have_attributes(name: :a, clean_name: :a),
          have_attributes(name: :a=, clean_name: :a)
        )
      end
    end
  end
end
