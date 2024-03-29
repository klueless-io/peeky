# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Style/OptionalBooleanParameter
module Sample
  class ForClassDebugRender
    # Check that attr_* is handled
    attr_accessor :a
    attr_reader   :b
    attr_writer   :c

    def simple(first_param); end

    def complex(aaa, bbb = 1, *ccc, ddd:, eee: 1, **fff, &ggg); end

    def test(aaa, bbb = 123, ccc = 'abc', ddd = true, eee = false, fff: 123, ggg: 'xyz', hhh: true, iii: false); end

    private

    def keep_private(first_param); end
  end
end
# rubocop:enable Style/OptionalBooleanParameter

RSpec.describe Peeky::Renderer::ClassDebugRender do
  subject { instance }

  let(:instance) { described_class.new(class_info) }
  let(:class_info) { Peeky::ClassInfo.new(target_instance) }
  let(:target_instance) { Sample::ForClassDebugRender.new }
  let(:method_name) { :simple }

  # describe '#constructor' do
  #   context 'with default parameters' do
  #     it { is_expected.not_to be_nil }
  #   end
  # end

  # describe '#render' do
  #   subject { instance.render }

  #   it do
  #     subject
  #   end
  # end

  describe '#debug' do
    it { puts instance.render } # uncomment to print debug content
  end
end
