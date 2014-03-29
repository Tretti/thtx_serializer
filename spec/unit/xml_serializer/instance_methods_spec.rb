# encoding: utf-8
require 'spec_helper'

describe 'InstanceMethods' do
  describe '#as_xml' do
    it 'will call :to_xml on Converter' do
      local_mock = Struct.new(:__hash_data__) do
        include THTXSerializer::InstanceMethods

        def self.xml_options
          {}
        end
      end

      mock_struct = local_mock.new([])

      expect(THTXSerializer::Converter).to receive(:to_xml).with([], {})

      mock_struct.as_xml
    end
  end

  describe '#__hash_data__' do
    it 'will create a new Hasher instance when called' do
      hasher = double THTXSerializer::Hasher

      local_mock = Class.new do
        include THTXSerializer::InstanceMethods
      end

      mock_struct = local_mock.new

      expect(THTXSerializer::Hasher).to receive(:new).with(mock_struct)
        .and_return(hasher)

      expect(hasher).to receive(:to_hash)

      mock_struct.__hash_data__
    end
  end
end
