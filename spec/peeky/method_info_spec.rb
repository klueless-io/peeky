# frozen_string_literal: true

require 'spec_helper'

class SampleClassMethodInfo
  attr_accessor :read_write

  def simple(first_param); end

  def complex(aaa, bbb = 1, *ccc, ddd:, eee: 1, **fff, &ggg); end

  def test(aaa, bbb = 1, ccc = "it's a \"string\"", ddd: "it's also a \"string\"" ); end

  def to_s; end
end

RSpec.describe Peeky::MethodInfo do
  subject { instance }

  let(:instance) { described_class.new(sample_method, target_instance) }
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

        it { is_expected.to start_with '#<Method: Kernel#to_s' }
      end
    end
  end

  describe '#get_parameter' do
    subject { instance.get_parameter(name) }
    
    let(:name) { :first_param }

    context 'with simple method' do
      it { is_expected.not_to be_nil }

      it do
        is_expected.to have_attributes(name: 'first_param',
                                       type: :param_required,
                                       signature_format: 'first_param',
                                       minimal_call_format: "'first_param'")
      end
    end
  end

  describe '.parameters' do
    subject { instance.parameters }

    context 'with simple method' do
      it { is_expected.to have_attributes(length: 1) }

      it do
        is_expected.to include(
          have_attributes(name: 'first_param',
                          type: :param_required,
                          signature_format: 'first_param',
                          minimal_call_format: "'first_param'")
        )
      end
    end

    context 'with complex method' do
      let(:method_name) { :complex }

      it { is_expected.to have_attributes(length: 7) }

      it do
        # def complex(aaa, bbb = 1, *ccc, ddd:, eee: 1, **fff, &ggg); end

        is_expected.to include(
          have_attributes(name: 'aaa', type: :param_required, signature_format: 'aaa'       , minimal_call_format: "'aaa'"),
          have_attributes(name: 'bbb', type: :param_optional, signature_format: 'bbb = 1'   , minimal_call_format: ''),
          have_attributes(name: 'ccc', type: :splat         , signature_format: '*ccc'      , minimal_call_format: ''),
          have_attributes(name: 'ddd', type: :key_required  , signature_format: 'ddd:'      , minimal_call_format: "ddd: 'ddd'"),
          have_attributes(name: 'eee', type: :key_optional  , signature_format: 'eee: 1'    , minimal_call_format: ''),
          have_attributes(name: 'fff', type: :double_splat  , signature_format: '**fff'     , minimal_call_format: ''),
          have_attributes(name: 'ggg', type: :block         , signature_format: '&ggg'      , minimal_call_format: '')
        )
      end
    end

    # Stage 2
    describe '#infer_implementation_type' do
      subject { instance.infer_implementation_type }

      context 'when simple method' do
        let(:method_name) { :simple }
        it { is_expected.to eq :method }
      end
      context 'when reader method' do
        let(:method_name) { :read_write }
        it { is_expected.to eq :attr_reader }
      end
      context 'when writer method' do
        let(:method_name) { :read_write= }
        it { is_expected.to eq :attr_writer }
      end
    end

    # Stage 3
    describe '#infer_default_paramaters' do
      subject  { instance.infer_default_paramaters }

      # let(:method_name) { :test }
      # # let(:method_name) { :complex }

      # it do
      #   puts instance.parameters.map { |p| p.inspect }
      #   # def test(aaa, bbb = 1, ccc = "it's a \"string\"", ddd: "it's also a \"string\"" ); end

      #   instance.infer_default_paramaters(target_instance)
      #   puts '-' * 70
      #   puts instance.parameters.map { |p| p.inspect }
      # end
    end
  end
end
