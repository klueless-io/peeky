# frozen_string_literal: true

require 'spec_helper'

module Sample
  module HowDeepIs
    module TheRabbitHole
      class ForClassInfoSpec
        attr_accessor :a # produces two signatures
        attr_reader   :b
        attr_writer   :c

        def d; end

        def simple(first_param); end

        def complex(aaa, bbb = 1, *ccc, ddd:, eee: 1, **fff, &ggg); end
      end
    end
  end
end

RSpec.describe Peeky::ClassInfo do
  subject { instance }

  let(:instance) { described_class.new(target_instance) }
  let(:target_instance) { Sample::HowDeepIs::TheRabbitHole::ForClassInfoSpec.new }

  describe '#constructor' do
    context 'with default parameters' do
      it { is_expected.not_to be_nil }

      it do
        is_expected.to have_attributes(class_name: 'ForClassInfoSpec',
                                       module_name: 'Sample::HowDeepIs::TheRabbitHole',
                                       class_full_name: 'Sample::HowDeepIs::TheRabbitHole::ForClassInfoSpec')
      end
    end
  end

  describe '#methods' do
    subject { instance.methods }

    it { is_expected.to have_attributes(length: 3) }
  end

  describe '#method_by_name' do
    subject { instance.method_by_name(name) }

    let(:name) { :simple }

    it { is_expected.not_to be_nil }

    context 'when not a standard method' do
      let(:name) { :a }

      it { is_expected.to be_nil }
    end
  end

  describe '#reader_by_name' do
    subject { instance.reader_by_name(name) }

    let(:name) { :a }

    it { is_expected.not_to be_nil }

    context 'when not a standard reader' do
      let(:name) { :simple }

      it { is_expected.to be_nil }
    end
  end

  describe '#writer_by_name' do
    subject { instance.writer_by_name(name) }

    let(:name) { :a= }

    it { is_expected.not_to be_nil }

    context 'when not a standard writer' do
      let(:name) { :simple }

      it { is_expected.to be_nil }
    end
  end

  describe '#signatures' do
    subject { instance.signatures }

    it { is_expected.to have_attributes(length: 7) }
  end

  describe '#attribute_infos' do
    subject { instance.attribute_infos }

    it { is_expected.to have_attributes(length: 3) }

    describe '#accessors' do
      subject { instance.accessors }

      it { is_expected.to have_attributes(length: 1) }
      it do
        is_expected.to include(
          have_attributes(
            type: :attr_accessor,
            reader: be_a(Peeky::MethodInfo).and(be_readable),
            writer: be_a(Peeky::MethodInfo).and(be_writable)
          )
        )
      end
    end

    describe '#readers' do
      subject { instance.readers }

      it { is_expected.to have_attributes(length: 1) }
      it do
        is_expected.to include(
          have_attributes(
            type: :attr_reader,
            reader: be_a(Peeky::MethodInfo).and(be_readable),
            writer: be_nil
          )
        )
      end
    end

    describe '#writers' do
      subject { instance.writers }

      it { is_expected.to have_attributes(length: 1) }
      it do
        is_expected.to include(
          have_attributes(
            type: :attr_writer,
            reader: be_nil,
            writer: be_a(Peeky::MethodInfo).and(be_writable)
          )
        )
      end
    end
  end

  describe '#signatures_by_name' do
    subject { instance.signatures_by_name(name) }

    context 'when simple method' do
      let(:name) { :simple }

      it { is_expected.to have_attributes(length: 1) }
      it { is_expected.to include(have_attributes(name: :simple, implementation_type: :method)) }
    end

    context 'when attribute reader method' do
      let(:name) { :a }

      it { is_expected.to have_attributes(length: 1) }
      it { is_expected.to include(have_attributes(name: :a, implementation_type: :attr_reader)) }
    end

    context 'when attribute writer method' do
      let(:name) { :a= }

      it { is_expected.to have_attributes(length: 1) }
      it { is_expected.to include(have_attributes(name: :a=, implementation_type: :attr_writer)) }
    end

    context 'when filter_type is' do
      subject { instance.signatures_by_name(name, filter_type: filter_type) }
      let(:name) { :simple }

      context ':all' do
        let(:filter_type) { :all }
        it { is_expected.to include(have_attributes(name: :simple, implementation_type: :method)) }
      end

      context ':method' do
        let(:filter_type) { :method }
        it { is_expected.to include(have_attributes(name: :simple, implementation_type: :method)) }
      end

      context ':attr_reader' do
        let(:filter_type) { :attr_reader }
        it { is_expected.not_to include(have_attributes(name: :simple, implementation_type: :method)) }
        context 'when attribute reader method' do
          let(:name) { :a }
          it { is_expected.to include(have_attributes(name: :a, implementation_type: :attr_reader)) }
        end
      end

      context ':attr_writer' do
        let(:filter_type) { :attr_writer }
        it { is_expected.not_to include(have_attributes(name: :simple, implementation_type: :method)) }
        context 'when attribute writer method' do
          let(:name) { :a= }
          it { is_expected.to include(have_attributes(name: :a=, implementation_type: :attr_writer)) }
        end
      end
    end
  end

  describe '#signatures_by_clean_name' do
    subject { instance.signatures_by_clean_name(clean_name) }

    context 'when simple method' do
      let(:clean_name) { :simple }

      it { is_expected.to have_attributes(length: 1) }
      it { is_expected.to include(have_attributes(clean_name: :simple)) }
    end

    context 'when attribute accessible (reader & writer) method' do
      let(:clean_name) { :a }

      it { is_expected.to have_attributes(length: 2) }
      it do
        is_expected.to include(
          have_attributes(name: :a, clean_name: :a),
          have_attributes(name: :a=, clean_name: :a)
        )
      end
    end
  end
end
