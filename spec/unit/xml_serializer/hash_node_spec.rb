# encoding: utf-8
require 'spec_helper'

describe 'HashNode' do
  subject { THTXSerializer::HashNode }

  describe '#build' do
    context 'given an empty key' do
      it 'will raise a RuntimeError' do
        result = subject.new(nil, 'A String')

        expect { result.build }.to raise_error(RuntimeError)
      end
    end

    context 'given empty data' do
      it 'will build an empty node' do
        expected = { :"mock_method/" => '' }
        result = subject.new(:mock_method, nil)

        expect(result.build).to eq expected
      end
    end

    context 'given an object that does not respond to #empty?' do
      it 'will raise a no method error' do
        mock_struct = Struct.new(:__hash_data__)

        result = subject.new(:mock_method, mock_struct.new(''))

        expect { result.build }.to raise_error(NoMethodError)
      end
    end

    context 'given a key and data' do
      it 'will produce a hash' do
        expected = { mock_method: 'A String' }
        result = subject.new(:mock_method, 'A String')

        expect(result.build).to eq expected
      end
    end

    context 'given a key, data and in_key' do
      it 'will produce a nested hash' do
        expected = { a_node: { mock_method: 'A String' } }
        result = subject.new(:mock_method, 'A String', :a_node)

        expect(result.build).to eq expected
      end
    end

    context 'given a key and an Array of objects' do
      it 'will produce a nested hash' do
        expected = { mock_methods: { mock_method: %w[string string2] } }
        result = subject.new(:mock_method, %w[string string2])

        expect(result.build).to eq expected
      end
    end

    context 'given a pluralized key and an Array of objects' do
      it 'will produce a nested hash' do
        expected = { mock_methods: { mock_method: %w[string string2] } }
        result = subject.new(:mock_methods, %w[string string2])

        expect(result.build).to eq expected
      end
    end

    context 'given a key and an empty Array' do
      it 'will produce a hash with empty value' do
        expected = { :'mock_methods/' => '' }
        result = subject.new(:mock_method, [])

        expect(result.build).to eq expected
      end
    end
  end
end
