# encoding: utf-8
require 'thtx_serializer'

class SerializableClass
  include THTXSerializer

  class ChildNode
    include THTXSerializer

    attr_reader :name, :content

    xml_attr :name, into: :child_name
    xml_attr :content, into: :child_content

    def initialize(name, content)
      @name = name
      @content = content
    end
  end

  xml_options namespace: :testing_testing,
              root_node: :thtx_serialized_node,
              namespace_definitions: {
                'xmlns:integration' =>
                  'http://schemas.example.com/integration/0.1/',
                'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                'xsi:schemaLocation' =>
                   'http://schemas.example.com/integration/0.1/integration.xsd'
              }

  xml_attr :a_string_node, in: :in_node
  xml_attr :a_time_node, into: :created_at
  xml_attr :child_nodes, into: :child
  xml_attr :empty_node

  def a_string_node
    'Some string'
  end

  def a_time_node
    '2014-03-27T20:42:05+01:00'
  end

  def child_nodes
    [
      ChildNode.new('child1', %w[string1 string2]),
      ChildNode.new('child2', %w[string1 string2])
    ]
  end

  def empty_node
    []
  end
end
