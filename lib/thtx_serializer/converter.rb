require 'gyoku'
require 'nokogiri'

module THTXSerializer
  # This module depends upon Nokogiri to massage the output and
  # Gyoku to actually parse the data.
  module Converter
    extend self

    # @param [Hash] hash a collection of objects serialized into a hash.
    # @param [Hash] options a hash, this currently supports
    #        namespace: 'integration'
    #        root_node: 'sync_request' by default the top element will be used
    #        namespace_definitions: { 'xmlns:integration' => "http://schemas.example.com/integration/0.1/" }
    #        human_readable: true
    #        key_converter: :camelcase See Gyoku for further details
    #
    # @return [String] A String containing XML.
    def to_xml(hashed_data, options = {})
      merged_options = default_options.merge(extract_options(options))
      root_node, hashed_data = extract_root_node(options, hashed_data)
      namespace_definitions = extract_namespace_definitions(options, root_node)

      content = compose_content(hashed_data, root_node, namespace_definitions)

      if options[:human_readable]
        massage_formatting Gyoku.xml(content, merged_options)
      else
        Gyoku.xml(content, merged_options)
      end
    end

    private

    # @param [Hash] hashed_data the content to serialize.
    # @param [Symbol] root_node the base of the XML structure.
    # @param [Hash] namespace_definitions
    #
    # @return [String] A String containing XML.
    def compose_content(hashed_data, root_node, namespace_definitions)
      if root_node
        { root_node.to_sym => hashed_data }.merge namespace_definitions
      else
        hashed_data
      end
    end

    # As the normal state of the generated XML is a plain unreadable string,
    # we can `massage` it into a more readable version by using Nokogiri.
    #
    # @param [String] xml_string
    # @return [String]
    def massage_formatting(xml_string)
      Nokogiri::XML::Document.parse(xml_string).to_xml
    end

    # @param [Hash] options
    # @return [Hash]
    def extract_options(options)
      extract_namespace(options).merge(extract_key_converter(options))
    end

    # @param [Hash] options
    # @return [Hash]
    def extract_key_converter(options)
      key_converter = options[:key_converter]
      if key_converter
        { key_converter: key_converter }
      else
        {}
      end
    end

    # @param [Hash] options hash to extract :namespace from.
    # @return [Hash]
    def extract_namespace(options)
      namespace = options[:namespace]

      if namespace
        { namespace: namespace, element_form_default: :qualified }
      else
        {}
      end
    end

    # @param [Hash] options
    # @param [Symbol] root_node
    #
    # @return [Hash] An empty hash or a hash consisting of the attributes
    #                under the root node.
    def extract_namespace_definitions(options, root_node)
      namespace_definitions = options[:namespace_definitions]

      if namespace_definitions && root_node
        { attributes!: { root_node => namespace_definitions } }
      else
        {}
      end
    end

    # @param [Hash] options a hash containing several options.
    # @param [Hash] hashed_data containing the data structure we are working on.
    #
    # @return [Array<Symbol, Hash>, FalseClass]
    def extract_root_node(options, hashed_data)
      if hashed_data.length == 1
        root_node = hashed_data.keys.first
        hashed_data = hashed_data[root_node]
      else
        root_node = options[:root_node]
      end

      if root_node
        [root_node, hashed_data]
      else
        false
      end
    end

    # @return [Hash]
    def default_options
      { key_converter: :none }
    end
  end
end
