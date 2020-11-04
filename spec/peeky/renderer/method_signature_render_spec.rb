# frozen_string_literal: true

require 'spec_helper'

class SampleClassMethodSignatureRender
  def simple(first_param); end

  def complex(aaa, bbb = 1, *ccc, ddd:, eee: 1, **fff, &ggg); end
end

RSpec.describe Peeky::Renderer::MethodSignatureRender do
  subject { instance }

  let(:instance) { described_class.new(method_signature) }
  let(:method_signature) { Peeky::MethodInfo.new(method) }
  let(:method) { target_instance.method(method_name) }
  let(:target_instance) { SampleClassMethodSignatureRender.new }
  let(:method_name) { :simple }

  describe '#constructor' do
    context 'with default parameters' do
      it { is_expected.not_to be_nil }
    end
  end

  describe '#render' do
    subject { instance.render }

    it { is_expected.to start_with('def simple(first_param);') }

    context 'when complex method' do
      let(:method_name) { :complex }

      it { is_expected.to start_with('def complex(aaa, bbb = nil, *ccc, ddd:, eee: nil, **fff, &ggg);') }
    end
  end

  describe '#debug' do
    subject { instance.debug }
    # let(:method_name) { :complex }
    # it { is_expected } # uncomment to print debug content
  end
end
