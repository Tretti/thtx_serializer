# encoding: utf-8

module THTXSerializer
  # Manages the creation of the object hash.
  # When invoked it will produce a hash representation of the object
  # according to the defined attributes.
  #
  class Hasher
    # @param [Object] obj an object that includes THTXSerializer
    # @return [THTXSerializer]
    def initialize(obj)
      @node = obj
    end

    # @return [Hash]
    #         The object and the contained data transformed into a hash.
    #
    def to_hash
      node.class.xml_attributes.each_with_object({}) do |(key, options), hash|
        combine_hashes(key, options, hash)
      end
    end

    private

    # @return [Object]
    def node
      @node
    end

    # @param [Symbol] key the hash key in question.
    # @param [Hash] options to apply to this node.
    # @param [Hash] hash the structure to work with.
    #
    # @return [Hash] returns the hash with the new content applied
    def combine_hashes(key, options, hash)
      hash.merge!(build_node(key, options)) do |_, left, right|
        if left.is_a?(Hash) && right.is_a?(Hash)
          left.merge(right)
        else
          right
        end
      end
    end

    # @param [Object] key to hold the data
    # @param [Object] data to be contained inside the node
    # @param [Hash] options
    def build_node(key, options)
      options_copy = options.dup
      produced_key, data, in_key = produce_data(key, options_copy)
      THTXSerializer::HashNode.new(produced_key, data, in_key).build
    end

    # @param [Symbol, String] key
    # @param [Hash] options
    #
    # @return [Hash]
    def produce_data(key, options)
      xml_key = (options.delete(:into) { key }).to_sym
      in_key = options.delete(:in) { nil }
      if options.any?
        fail ArgumentError, "Unrecognized option(s): #{options}"
      end

      data = collect_data(key)

      [xml_key, data, in_key]
    end

    # @param [Symbol] key
    # @return [Object] returns the generated data from the method call.
    def collect_data(key)
      result = node.send(key)

      calling_block = lambda do |obj|
        obj.respond_to?(:__hash_data__) ? obj.__hash_data__ : obj
      end

      if result.respond_to?(:each)
        handle_enumerable(result, &calling_block)
      else
        handle_regular_object(result, &calling_block)
      end
    end

    # @param [Enumerable] enum an object that implements each.
    # @return [Array]
    def handle_enumerable(enum, &block)
      enum.map { |obj| block.call(obj) }
    end

    # @param [Object] obj any object that is not an enumerable.
    # @return [Object, Hash]
    def handle_regular_object(obj, &block)
      block.call(obj)
    end
  end
end
