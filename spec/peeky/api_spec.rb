# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Lint/EmptyClass
class SampleClassForApi
end
# rubocop:enable Lint/EmptyClass

RSpec.describe Peeky::Api do
  describe '#constructor' do
    subject { described_class.new }
    context 'with default parameters' do
      it { is_expected.not_to be_nil }
    end
  end

  describe 'Peaky#api' do
    let(:api) { Peeky.api }

    # let(:method_signature) { Peeky::MethodInfo.new(method, target_instance) }
    # let(:method) { target_instance.method(method_name) }
    # let(:method_name) { :simple }

    let(:target_instance) { SampleClassForApi.new }

    it { is_expected.not_to be_nil }

    it do
      sample = SampleClassForApi.new
      class_info_first = Peeky::ClassInfo.new(sample)
      class_interface_render = Peeky::Renderer::ClassInterfaceRender.new(class_info_first)
      class_info_second = Peeky::ClassInfo.new(class_interface_render)
      puts class_info_second.load
    end

    describe '#build_class_info' do
      subject { api.build_class_info(target_instance) }

      it { is_expected.not_to be_nil }
      it { is_expected.to be_a Peeky::ClassInfo }
    end

    context 'get renderers' do
      describe '#method_renderer' do
        subject { api.method_renderer(key) }

        context 'unknown' do
          let(:key) { :unknown }
          it { expect { subject }.to raise_error 'Unknown method renderer: unknown' }
        end

        context 'method signature' do
          let(:key) { :signature }
          it { is_expected.to eq(Peeky::Renderer::MethodSignatureRender) }
        end

        context 'method signature with debug' do
          let(:key) { :signature_with_debug }
          it { is_expected.to eq(Peeky::Renderer::MethodSignatureWithDebugRender) }
        end

        context 'calling a method with minimal parameters' do
          let(:key) { :call_minimum_params }
          it { is_expected.to eq(Peeky::Renderer::MethodCallMinimumParamsRender) }
        end
      end

      describe '#class_renderer' do
        subject { api.class_renderer(key) }

        context 'render the class interface' do
          let(:key) { :class_interface }

          it { is_expected.to eq(Peeky::Renderer::ClassInterfaceRender) }
        end

        context 'render the class interface with YARD documentation' do
          let(:key) { :class_interface_yard }

          it { is_expected.to eq(Peeky::Renderer::ClassInterfaceYardRender) }
        end
      end
    end

    context 'execute class rendering' do
      subject { api.render_class(key, class_info: class_info, instance: instance) }

      let(:key) { :unknown }
      let(:instance) { nil }
      let(:class_info) { nil }

      context 'when neither class_info or instance supplied' do
        it { expect { subject }.to raise_error 'Call render_class with class_info OR instance.' }
      end

      context 'when class_info and instance are both supplied' do
        let(:instance) { 'something' }
        let(:class_info) { 'something' }
        it { expect { subject }.to raise_error 'Call render_class with class_info OR instance, these parameters are mutually exclusive' }
      end

      context 'when instance supplied' do
        let(:instance) { SampleClassForApi.new }
        context 'with unknown render key' do
          it { expect { subject }.to raise_error 'Unknown class renderer: unknown' }
        end
        context 'with known render key' do
          let(:key) { :class_interface }

          it { is_expected.not_to be_nil }
        end
      end
    end
    # describe '#render_method' do
    #   subject { instance.render_method(method_signature, instance_name: 'instance') }
    #   it { is_expected } # uncomment to print debug content
    # end
  end
end
