# frozen_string_literal: true

require 'spec_helper'

class SampleClassMethodSignatureWithDebugRender
  def simple(first_param); end

  def complex(aaa, bbb = 1, *ccc, ddd:, eee: 1, **fff, &ggg); end
end

RSpec.describe Peeky::Renderer::MethodSignatureWithDebugRender do
  subject { instance }

  let(:instance) { described_class.new(method_signature) }
  let(:method_signature) { Peeky::MethodInfo.new(method) }
  let(:method) { target_instance.method(method_name) }
  let(:target_instance) { SampleClassMethodSignatureWithDebugRender.new }
  let(:method_name) { :simple }

  describe '#constructor' do
    context 'with default parameters' do
      it { is_expected.not_to be_nil }
    end
  end

  describe '#render' do
    subject { instance.render }

    it { is_expected.to start_with('def simple(first_param)') }
    it { is_expected.to include('puts first_param') }
  end

  describe '#debug' do
    # let(:method_name) { :complex }
    # it { is_expected } # uncomment to print debug content
  end
end
