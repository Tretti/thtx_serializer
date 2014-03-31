# encoding: utf-8
require 'active_support/inflector'

module THTXSerializer
  # Essentially a class to delegate responsibility to create the hash node from
  # the ground up.
  #
  class HashNode
    attr_reader :key, :data, :in_key

    # @param [Symbol, String] key
    # @param [Object] data
    # @param [Symbol, String] in_key
    #
    # @return [THTXSerializer]
    def initialize(key, data, in_key = nil)
      @key = key
      @data = data
      @in_key = in_key
    end

    # Build a hash node from the data provided.
    #
    # @return [Hash]
    def build
      fail "Please provide a value for key, currently: #{key}" if key.nil?

      if in_key
        { in_key.to_sym => { key => data } }
      else
        process_data
        transform_to_hash
      end
    end

    private

    attr_writer :key, :collection_key

    # @param [Symbol] collection_key the key used if a collection
    #                 is to be wrapped.
    #
    # @return [Hash] The hash produced by calling the method.
    def transform_to_hash
      if collection_key
        { collection_key.to_sym => { singularize_key.to_sym => data } }
      else
        { key => data }
      end
    end

    # @return [Symbol, NilClass] provides either a nil or a collection symbol.
    def process_data
      if data.is_a?(Array) || data.is_a?(Set)
        self.collection_key = process_collection
      elsif (data.is_a?(String) && data.empty?) || data.nil?
        process_empty_object
      end
    end

    # @return [Symbol, NilClass]
    def process_collection
      if data.empty?
        clear_data!
        pluralize_empty_collection_node_key!
        nil
      else
        pluralize_key
      end
    end

    # @return [Object]
    def collection_key
      @collection_key
    end

    # If the data attribute is empty, we need to create a self closing node key.
    # We also :clear_data! in the node.
    #
    # @return [Symbol]
    def process_empty_object
      clear_data!
      self.key = transform_to_empty_key(key)
    end

    # Clear out the data variable, otherwise we can't create an empty node
    # This will always become an empty string.
    #
    # @return [String] and empty string.
    def clear_data!
      @data = ''
    end

    # Rewrite the key for a node with an empty array.
    #
    # @return [Symbol]
    def pluralize_empty_collection_node_key!
      self.key = transform_to_empty_key(pluralize_key)
    end

    # Turn a node into an empty node
    #
    # @return [Symbol]
    def transform_to_empty_key(key)
      (key.to_s << '/').to_sym
    end

    # A wrapping for ActiveSupport
    #
    # @return [String]
    def singularize_key
      ActiveSupport::Inflector.singularize(key)
    end

    # A wrapping for ActiveSupport.
    #
    # @return [String]
    def pluralize_key
      ActiveSupport::Inflector.pluralize(key)
    end
  end
end
