require 'active_support/inflector'

module THTXSerializer
  class Hasher
    attr_reader :node

    def initialize(obj)
      @node = obj
    end

    # @return [Hash]
    #         The object and the contained data transformed into a hash.
    #
    def hash_object
      node.class.xml_attributes.each_with_object({}) do |(key, options), hash|
        hash.merge!(produce_data(key, options))
      end
    end

    private

    # @param [Symbol, String] key
    # @param [Hash] options
    #
    # @return [Hash]
    def produce_data(key, options)
      xml_key = options.fetch(:into, key).to_sym
      in_key = options[:in]

      data = collect_data(key)

      if in_key
        { in_key.to_sym => { xml_key => data } }
      else
        if data.is_a?(Array)
          if data.empty?
            data = ''
            xml_key = (pluralize(xml_key).to_s << '/').to_sym
          else
            collection_key = pluralize(xml_key)
          end
        end

        create(xml_key, data, collection_key)
      end
    end

    # @param [Symbol] xml_key node name in the xml tree.
    # @param [Object] data the generated method object.
    #
    # @param [Symbol] collection_key the key used if a collection
    #                 is to be wrapped.
    #
    # @return [Hash] The hash produced by calling the method.
    def create(xml_key, data, collection_key)
      if collection_key
        { collection_key.to_sym => { xml_key => data } }
      else
        { xml_key => data }
      end
    end

    # @param [Symbol] key
    # @return [Object] returns the generated data from the method call.
    def collect_data(key)
      result = node.send(key)

      if result.respond_to?(:each)
        result.map do |obj|
          obj.respond_to?(:__hash_data__) ? obj.__hash_data__ : obj
        end
      else
        result.respond_to?(:__hash_data__) ? result.__hash_data__ : result
      end
    end

    # A wrapping for ActiveSupport.
    #
    # @param [String, Symbol] key
    # @return [String]
    def pluralize(key)
      ActiveSupport::Inflector.pluralize(key)
    end
  end
end
