# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/ParameterLists
class SampleClassMethodInfo
  attr_accessor :read_write

  def simple(first_param); end

  def complex(aaa, bbb = 1, *ccc, ddd:, eee: 1, **fff, &ggg); end

  def to_s; end
end
# rubocop:enable Metrics/ParameterLists

RSpec.describe Peeky::MethodInfo do
  subject { instance }

  let(:instance) { described_class.new(sample_method) }
  let(:sample_method) { target_instance.method(method_name) }
  let(:method_name) { :simple }
  let(:target_instance) { SampleClassMethodInfo.new }

  describe '#constructor' do
    context 'with default parameters' do
      it { is_expected.not_to be_nil }
      # it { is_expected.to have_attributes()}
    end
  end

  context 'accessors' do
    describe '.parameters' do
      subject { instance.parameters }

      it { is_expected.to have_attributes(length: 1) }
    end

    describe '.name' do
      subject { instance.name }

      it { is_expected.to eq :simple }
    end

    describe '.receiver' do
      subject { instance.receiver }

      it { is_expected.to be_a(SampleClassMethodInfo) }
    end

    describe '.arity' do
      subject { instance.arity }

      it { is_expected.to eq 1 }
    end

    describe '.super_method' do
      subject { instance.super_method.to_s }

      it { is_expected.to eq '' }

      context 'when parent class has super method' do
        let(:method_name) { :to_s }

        it { is_expected.to eq '#<Method: Kernel#to_s()>' }
      end
    end
  end
end
