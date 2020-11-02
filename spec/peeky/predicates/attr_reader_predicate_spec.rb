# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Style/TrivialAccessors
class SampleClassAttrReaderPredicate
  # Match
  attr_accessor :read_write
  # Match
  attr_reader :read
  # No match
  attr_writer :write

  def edge_case?; end

  def edge_case!; end

  def edge_case=; end

  # Match (unfortunately)
  def memoized_reader
    @memoized_reader ||= 'behaves just like attr_reader, but is not really an attr_reader'
  end

  # No match
  def just_a_method
    'just some method'
  end

  # No match
  def standard_method(abc)
    @standard_method = abc
  end
end
# rubocop:enable Style/TrivialAccessors

RSpec.describe Peeky::Predicates::AttrReaderPredicate do
  subject { instance }

  let(:instance) { described_class.new }

  describe '#constructor' do
    context 'with default parameters' do
      it { is_expected.not_to be_nil }
    end
  end

  describe '#match' do
    let(:instance) { described_class.new.match(target_instance, method_signature) }
    let(:method_signature) { Peaky::MethodInfo.new(method) }
    let(:method) { target_instance.method(method_name) }
    let(:target_instance) { SampleClassAttrReaderPredicate.new }
    let(:method_name) { :memoized_reader }

    context 'when attr_accessor (read_write)' do
      let(:method_name) { :read_write }
      it { is_expected.to be_truthy }
    end

    context 'when attr_reader (read)' do
      let(:method_name) { :read }
      it { is_expected.to be_truthy }
    end

    context 'when attr_writer (write)' do
      let(:method_name) { :write= }
      it { is_expected.to be_falsy }
    end

    context 'when memoized_reader (method that looks like attr_reader, but is not)' do
      let(:method_name) { :memoized_reader }
      it { is_expected.to be_truthy }
    end

    context 'when just_a_method (method with same characteristics as a attr_reader)' do
      let(:method_name) { :just_a_method }
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

    context 'when ending with =' do
      let(:method_name) { :edge_case= }
      it { is_expected.to be_falsy }
    end
  end
end
