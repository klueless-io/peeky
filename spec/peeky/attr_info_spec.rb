# frozen_string_literal: true

require 'spec_helper'

class SampleClassAttrInfo
  attr_accessor :read_write

  def simple(first_param); end
end

RSpec.describe Peeky::AttrInfo do
  subject { instance }

  let(:instance) { described_class.new(**args) }
  let(:args) { {} }
  let(:target_instance) { SampleClassAttrInfo.new }

  def method_info(method_name)
    method = target_instance.method(method_name)
    Peeky::MethodInfo.new(method, target_instance)
  end

  describe '#constructor' do
    context 'when no parameters' do
      it { expect { subject }.to raise_error 'AttrInfo requires at least one read or write parameter' }
    end

    context 'when invalid reader parameter type' do
      let(:args) { { reader: Object.new } }
      it { expect { subject }.to raise_error 'reader: parameter must be of type MethodInfo' }
    end

    context 'when reader method does not implement the :attr_reader signature' do
      let(:args) { { reader: method_info(:simple) } }
      it { expect { subject }.to raise_error 'reader: method does not implement the :attr_reader signature' }
    end

    context 'when invalid writer parameter type' do
      let(:args) { { writer: Object.new } }
      it { expect { subject }.to raise_error 'writer: parameter must be of type MethodInfo' }
    end

    context 'when writer method does not implement the :attr_writer signature' do
      let(:args) { { writer: method_info(:simple) } }
      it { expect { subject }.to raise_error 'writer: method does not implement the :attr_writer signature' }
    end

    context 'with valid reader method' do
      let(:args) { { reader: method_info(:read_write) } }

      it { is_expected.to have_attributes(type: :attr_reader) }
      it { expect(subject.reader).not_to be_nil }
      it { expect(subject.writer).to be_nil }
    end

    context 'with valid writer method' do
      let(:args) { { writer: method_info(:read_write=) } }

      it { is_expected.to have_attributes(type: :attr_writer) }
      it { expect(subject.reader).to be_nil }
      it { expect(subject.writer).not_to be_nil }
    end

    context 'with valid reader/writer methods' do
      let(:args) { { reader: method_info(:read_write), writer: method_info(:read_write=) } }

      it { is_expected.to have_attributes(type: :attr_accessor) }
      it { expect(subject.reader).not_to be_nil }
      it { expect(subject.writer).not_to be_nil }
    end
  end

  describe '#create - factory' do
    subject { described_class.create(*method_infos) }

    context 'with valid reader method' do
      let(:method_infos) { method_info(:read_write) }

      it { is_expected.to have_attributes(type: :attr_reader) }
      it { expect(subject.reader).not_to be_nil }
      it { expect(subject.writer).to be_nil }
    end

    context 'with valid writer method' do
      let(:method_infos) { method_info(:read_write=) }

      it { is_expected.to have_attributes(type: :attr_writer) }
      it { expect(subject.reader).to be_nil }
      it { expect(subject.writer).not_to be_nil }
    end

    context 'with valid reader/writer methods' do
      let(:method_infos) { [method_info(:read_write), method_info(:read_write=)] }

      it { is_expected.to have_attributes(type: :attr_accessor) }
      it { expect(subject.reader).not_to be_nil }
      it { expect(subject.writer).not_to be_nil }
    end
  end
end
