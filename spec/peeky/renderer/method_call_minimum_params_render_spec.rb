# frozen_string_literal: true

require 'spec_helper'

class SampleClassMinimalCallSignatureRender
  def simple(first_param); end

  def complex(aaa, bbb = 1, *ccc, ddd:, eee: 1, **fff, &ggg); end
end

RSpec.describe Peeky::Renderer::MethodCallMinimumParamsRender do
  subject { instance }

  let(:instance) { described_class.new(method_signature) }
  let(:method_signature) { Peeky::MethodInfo.new(method) }
  let(:method) { target_instance.method(method_name) }
  let(:target_instance) { SampleClassMinimalCallSignatureRender.new }
  let(:method_name) { :simple }

  describe '#constructor' do
    context 'with default parameters' do
      it { is_expected.not_to be_nil }
    end
  end

  describe '#render' do
    subject { instance.render }

    it { is_expected.to eq("instance.simple('first_param')") }

    context 'with instance name' do
      let(:instance) { described_class.new(method_signature, instance_name: 'var1') }

      it { is_expected.to eq("var1.simple('first_param')") }

      context 'when complex method' do
        let(:method_name) { :complex }

        it { is_expected.to eq("var1.complex('aaa', ddd: 'ddd')") }
      end
    end
  end

  describe '#debug' do
    # let(:method_name) { :complex }
    # it { puts instance.render } # uncomment to print debug content
  end
end
