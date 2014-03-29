# encoding: utf-8
require 'spec_helper'

describe 'Class Methods' do
  describe '.xml_attributes' do
    let(:test_class_attributes) do
      Class.new do
        include THTXSerializer
      end
    end
    it 'will hold the defined attributes in an array' do
      expect(test_class_attributes.xml_attributes).to eq({})
    end
  end

  describe '.xml_attr' do
    context 'given an attribute is defined' do
      let(:test_class_first) do
        Class.new do
          include THTXSerializer
          xml_attr :first
        end
      end

      it 'will be added to the list of attributes' do
        expect(test_class_first.xml_attributes).to eq(first: {})
      end
    end

    context 'given an attribute has already been defined' do
      let(:test_class_duplicate) do
        Class.new do
          include THTXSerializer
          xml_attr :duplicate
        end
      end

      it 'will raise an error' do
        expect { test_class_duplicate.send(:xml_attr, :duplicate) }
        .to raise_error(RuntimeError)
      end
    end

    context 'given an options hash is given' do
      let(:test_class_as) do
        Class.new do
          include THTXSerializer
          xml_attr :first, in: :test_key
        end
      end

      it 'will be contained inside the list of attributes' do
        expect(test_class_as.xml_attributes).to eq(first: { in: :test_key })
      end
    end
  end

  describe '.xml_options' do
    let(:test_class_xml_options) do
      Class.new do
        include THTXSerializer
      end
    end

    context 'given no data is provided' do
      it 'will return the default options' do
        expect(test_class_xml_options.xml_options({}))
          .to eq(root_node: :class)
      end
    end

    context 'given data is provided' do
      it 'will merge default options and data' do
        expect(test_class_xml_options.xml_options(human_readable: true))
        .to eq(root_node: :class, human_readable: true)
      end
    end
  end
end
