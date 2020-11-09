# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Style/TrivialAccessors
class SampleClassAttrWriterPredicate
  # Match
  attr_accessor :read_write
  # No Match
  attr_reader :read
  # Match
  attr_writer :write

  def edge_case?; end

  def edge_case!; end

  # No match
  def standard_method(abc)
    @standard_method = abc
  end

  # Match
  def writer_look_alike=(abc)
    @writer_look_alike = abc
  end
end
# rubocop:enable Style/TrivialAccessors

RSpec.describe Peeky::Predicates::AttrWriterPredicate do
  subject { instance }

  let(:instance) { described_class.new }

  describe '#constructor' do
    context 'with default parameters' do
      it { is_expected.not_to be_nil }
    end
  end

  describe '#match' do
    let(:instance) { described_class.new.match(target_instance, method_signature) }
    let(:method_signature) { Peeky::MethodInfo.new(method, target_instance) }
    let(:method) { target_instance.method(method_name) }
    let(:target_instance) { SampleClassAttrWriterPredicate.new }
    let(:method_name) { :memoized_reader }

    context 'when attr_accessor (read_write)' do
      let(:method_name) { :read_write= }
      it { is_expected.to be_truthy }
    end

    context 'when attr_reader (read)' do
      let(:method_name) { :read }
      it { is_expected.to be_falsy }
    end

    context 'when attr_writer (write)' do
      let(:method_name) { :write= }
      it { is_expected.to be_truthy }
    end

    context 'when writer_look_alike (method with same characteristics as a attr_reader)' do
      let(:method_name) { :writer_look_alike= }
      it { is_expected.to be_falsy }
    end

    context 'when standard_method' do
      let(:method_name) { :standard_method }
      it { is_expected.to be_falsy }
    end

    context 'when ending with !' do
      let(:method_name) { :edge_case! }
      it { is_expected.to be_falsy }
    end

    context 'when ending with ?' do
      let(:method_name) { :edge_case? }
      it { is_expected.to be_falsy }
    end
  end
end
