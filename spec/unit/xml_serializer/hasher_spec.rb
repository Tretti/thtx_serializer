# encoding: utf-8
require 'spec_helper'

describe 'Hasher' do
  class MockClass
    include THTXSerializer
    class << self
      attr_writer :xml_attributes
    end
  end

  let(:obj) { MockClass.new }
  subject { THTXSerializer::Hasher.new(obj) }

  describe '#to_hash' do
    before :each do
      MockClass.send(:xml_attributes=, {})
    end

    context 'given no attributes have been defined' do
      it 'will return an empty hash' do
        expect(subject.to_hash).to eq({})
      end
    end

    context 'given attributes have been defined' do
      it 'will generate a hash' do
        obj.class.class_eval do
          def mock_method
            'A String'
          end
        end

        obj.class.send(:xml_attr, :mock_method)
        expected = { mock_method: 'A String' }

        expect(subject.to_hash).to eq expected
      end
    end

    context 'duplicate nodes in the hash' do
      context 'given there are two attrs with the same :in' do
        it 'will merge them into one hash' do
          obj.class.class_eval do
            xml_attr :mock_method, in: :defined_by_in
            xml_attr :mock_method2, in: :defined_by_in

            def mock_method
              'string1'
            end

            def mock_method2
              'string2'
            end
          end

          expected = { defined_by_in: {
            mock_method: 'string1',
            mock_method2: 'string2' }
          }

          expect(subject.to_hash).to eq expected
        end
      end

      context 'given there are two attrs but only one is a hash' do
        it 'the second node will overwrite the first' do
          obj.class.class_eval do
            xml_attr :mock_method, in: :defined_by_in
            xml_attr :defined_by_in

            def mock_method
              'string1'
            end

            def defined_by_in
              'string2'
            end
          end

          expected = { defined_by_in:  'string2' }

          expect(subject.to_hash).to eq expected
        end
      end
    end
  end

  describe '#produce_data' do
    context 'given an attribute and empty options' do
      it 'will produce a hash' do
        obj.class.class_eval do
          def mock_method
            'A String'
          end
        end

        result = subject.send(:produce_data, :mock_method, {})

        expect(result).to eq([:mock_method, 'A String', nil])
      end

      context 'given an attribute and option with the key :into' do
        it 'will produce a hash' do
          obj.class.class_eval do
            def mock_method
              'A String'
            end
          end

          result = subject.send(:produce_data, :mock_method, into: :into_key)

          expect(result).to eq([:into_key, 'A String', nil])
        end
      end

      context 'given an attribute and option with the key :in' do
        it 'will produce a hash with a new root element' do
          obj.class.class_eval do
            def mock_method
              'A String'
            end
          end

          result = subject.send(:produce_data, :mock_method, in: :in_key)

          expect(result).to eq([:mock_method, 'A String', :in_key])
        end
      end

      context 'given an attribute and incorrect options key' do
        it 'will raise an ArgumentError' do
          obj.class.class_eval do
            def mock_method
              'A String'
            end
          end

          expect do
            subject.send(:produce_data, :mock_method, inchala: :in_key)
          end.to raise_error(ArgumentError)
        end
      end

      context 'given an attribute that contains a collection' do
        context 'and no :in key option is provided' do
          it 'will produce a hash with the containing elements' do
            class TestClassAs
              def __hash_data__
                { test_class_as: { defined: 'on the class' } }
              end
            end

            obj.class.class_eval do
              def mock_method
                Array.new(3, TestClassAs.new) + Array.new(1, 'String')
              end
            end

            expected = [
              :row, [
                { test_class_as:
                  { defined: 'on the class' }
                }, { test_class_as: { defined: 'on the class' } },
                { test_class_as: { defined: 'on the class' } },
                'String'
              ],
              nil
            ]

            expect(subject.send(:produce_data, :mock_method, into: :row))
              .to eq(expected)
          end
        end
      end
    end
  end
end
