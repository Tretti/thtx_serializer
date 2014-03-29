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
    def build
      fail "Please provide a value for key, currently: #{key}" if key.nil?

      if in_key
        { in_key.to_sym => { key => data } }
      else
        if data.is_a?(Array)
          if data.empty?
            clear_data!
            pluralize_empty_node_key!
          else
            collection_key = pluralize_key
          end
        end

        create(collection_key)
      end
    end

    private

    attr_writer :key

    # @param [Symbol] collection_key the key used if a collection
    #                 is to be wrapped.
    #
    # @return [Hash] The hash produced by calling the method.
    def create(collection_key)
      if collection_key
        { collection_key.to_sym => { key => data } }
      else
        { key => data }
      end
    end

    # Clear out the data variable, otherwise we can't create an empty node
    def clear_data!
      @data = ''
    end

    # Rewrite the key for a node with an empty array.
    def pluralize_empty_node_key!
      self.key = (pluralize_key.to_s << '/').to_sym
    end

    # A wrapping for ActiveSupport.
    #
    # @return [String]
    def pluralize_key
      ActiveSupport::Inflector.pluralize(@key)
    end
  end
end
