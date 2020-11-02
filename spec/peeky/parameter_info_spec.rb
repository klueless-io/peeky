# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/ParameterLists
class SampleClassParameterInfo
  def simple(first_param); end

  def complex(aaa, bbb = 1, *ccc, ddd:, eee: 1, **fff, &ggg); end
end
# rubocop:enable Metrics/ParameterLists

RSpec.describe Peeky::ParameterInfo do
  subject { instance }

  let(:instance) { described_class.new([:req]) }

  describe '#constructor' do
    context 'factory class requires private method' do
      it { expect { described_class.new }.to raise_error NoMethodError }
    end
  end

  it 'debug' do
    described_class.from_parameter([:req, 'aaa']).debug
  end

  describe '#from_parameter' do
    let(:instance) { described_class.from_parameter(param) }

    context 'with attribute writer signature' do
      let(:param) { [:req] }

      it { is_expected.to have_attributes(name: '', type: :param_required, signature_format: '', minimal_call_format: "''") }
    end

    context 'with required positional parameter - simple(aaa)' do
      let(:param) { [:req, 'aaa'] }

      it { is_expected.to have_attributes(name: 'aaa', type: :param_required, signature_format: 'aaa', minimal_call_format: "'aaa'") }
    end

    context 'with optional positioned parameter - simple(aaa = nil)' do
      let(:param) { [:opt, 'aaa'] }

      it { is_expected.to have_attributes(name: 'aaa', type: :param_optional, signature_format: 'aaa = nil', minimal_call_format: '') }
    end

    context 'with splat positioned parameters - simple(*aaa)' do
      let(:param) { [:rest, 'aaa'] }

      it { is_expected.to have_attributes(name: 'aaa', type: :splat, signature_format: '*aaa', minimal_call_format: '') }
    end

    context "with required keyed/named parameter - simple(aaa: 'aaa')" do
      let(:param) { [:keyreq, 'aaa'] }

      it { is_expected.to have_attributes(name: 'aaa', type: :key_required, signature_format: 'aaa:', minimal_call_format: "aaa: 'aaa'") }
    end

    context 'with optional keyed/named parameter - simple(aaa: nil)' do
      let(:param) { [:key, 'aaa'] }

      it { is_expected.to have_attributes(name: 'aaa', type: :key_optional, signature_format: 'aaa: nil', minimal_call_format: '') }
    end

    context 'with optional keyed/named parameter - simple(&aaa)' do
      let(:param) { [:block, 'aaa'] }

      it { is_expected.to have_attributes(name: 'aaa', type: :block, signature_format: '&aaa', minimal_call_format: '') }
    end
  end

  describe '#from_method' do
    let(:instance) { described_class.from_method(SampleClassParameterInfo.new.method(:complex)) }

    it { is_expected.to include(have_attributes(name: 'aaa', type: :param_required, signature_format: 'aaa'       , minimal_call_format: "'aaa'")) }
    it { is_expected.to include(have_attributes(name: 'bbb', type: :param_optional, signature_format: 'bbb = nil' , minimal_call_format: '')) }
    it { is_expected.to include(have_attributes(name: 'ccc', type: :splat         , signature_format: '*ccc'      , minimal_call_format: '')) }
    it { is_expected.to include(have_attributes(name: 'ddd', type: :key_required  , signature_format: 'ddd:'      , minimal_call_format: "ddd: 'ddd'")) }
    it { is_expected.to include(have_attributes(name: 'eee', type: :key_optional  , signature_format: 'eee: nil'  , minimal_call_format: '')) }
    it { is_expected.to include(have_attributes(name: 'fff', type: :double_splat  , signature_format: '**fff'     , minimal_call_format: '')) }
    it { is_expected.to include(have_attributes(name: 'ggg', type: :block         , signature_format: '&ggg'      , minimal_call_format: '')) }
  end
end
