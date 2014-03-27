require_relative '../../support/lib/serializable_class'

describe 'THTXSerializer serialization' do
  subject { SerializableClass.new }

  describe 'a class has been set up with xml_attributes' do
    it 'will generate the xml document matching the class structure' do
      expected = "<testing_testing:thtx_serialized_node xmlns:integration=\"http://schemas.example.com/integration/0.1/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://schemas.example.com/integration/0.1/integration.xsd\"><testing_testing:in_node><testing_testing:a_string_node>Some string</testing_testing:a_string_node></testing_testing:in_node><testing_testing:created_at>2014-03-27T20:42:05+01:00</testing_testing:created_at><testing_testing:children><testing_testing:child><testing_testing:child_name>child1</testing_testing:child_name><testing_testing:child_contents><testing_testing:child_content>string1</testing_testing:child_content><testing_testing:child_content>string2</testing_testing:child_content></testing_testing:child_contents></testing_testing:child><testing_testing:child><testing_testing:child_name>child2</testing_testing:child_name><testing_testing:child_contents><testing_testing:child_content>string1</testing_testing:child_content><testing_testing:child_content>string2</testing_testing:child_content></testing_testing:child_contents></testing_testing:child></testing_testing:children><testing_testing:empty_nodes/></testing_testing:thtx_serialized_node>"

      expect(subject.as_xml).to eq expected
    end
  end
end
