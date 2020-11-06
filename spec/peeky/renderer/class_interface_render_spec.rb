# frozen_string_literal: true

require 'spec_helper'

class SampleClassClassInterfaceRender
  # Check that attr_* is handled
  attr_accessor :a
  attr_accessor :a1
  attr_accessor :a2
  attr_accessor :a3
  attr_reader   :b
  attr_writer   :c

  # Check that various method signatures are handled
  def d;                                                  end
  def e(aaa);                                             end
  def f(aaa, bbb = 1);                                    end
  def g(aaa, bbb = 1, ccc = 2);                           end
  def h(*aaa);                                            end
  def i(aaa, bbb, *ccc);                                  end
  def j(**aaa);                                           end
  def k(aaa, *bbb, **ccc);                                end
  def l(aaa, *bbb, **ccc, &ddd);                          end
  def m(aaa:);                                            end
  def n(aaa:, bbb: 1);                                    end
  def p?;                                                 end
  def q!;                                                 end
  def z(aaa, bbb = 1, *ccc, ddd:, eee: 1, **fff, &ggg);   end

  # Check that methods are sorted
  def alpha_sort2;                                        end
  def alpha_sort1;                                        end
end

RSpec.describe Peeky::Renderer::ClassInterfaceRender do
  subject { instance }

  let(:instance) { described_class.new(class_info) }
  let(:class_info) { Peeky::ClassInfo.new(target_instance) }
  let(:target_instance) { SampleClassClassInterfaceRender.new }
  let(:method_name) { :simple }

  describe '#constructor' do
    context 'with default parameters' do
      it { is_expected.not_to be_nil }
    end
  end

  describe '#render' do
    subject { instance.render }

    it do
      is_expected.to start_with('class SampleClassClassInterfaceRender')
        .and(include 'attr_accessor :a')
        .and(include 'attr_reader :b')
        .and(include 'attr_writer :c')
        .and(include 'def e(aaa);')
        .and(include 'def z(aaa, bbb = nil, *ccc, ddd:, eee: nil, **fff, &ggg);')
    end
  end

  describe '#debug' do
    # it { puts instance.render } # uncomment to print debug content
  end
end
