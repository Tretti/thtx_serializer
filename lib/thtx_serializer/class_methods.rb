# encoding: utf-8
module THTXSerializer
  # Contains the class methods that are appended to a class that includes the
  # Serializer.
  #
  # Be careful not to overwrite these methods with your own, as it will impede
  # the functionality of the Serializer.
  #
  module ClassMethods
    # The container for xml_attributes
    #
    # @return [Hash]
    def xml_attributes
      @xml_attributes ||= {}
    end

    # The default options to ensure the serialization will go off without
    # a hitch.
    #
    # @param [Hash] options
    # @return [Hash]
    def xml_options(options = {})
      @xml_options ||= default_options.merge(options)
    end

    private

    # @return [Hash]
    def default_options
      { root_node: name.downcase.to_sym }
    end

    # Defines the attributes on the class.
    #
    # @example
    #   xml_attr :method, { into: :into_key, in: :in_key }
    #   xml_attr :method2, { into: into_key }
    #   xml_attr :method3, { in: :in_key }
    #   xml_attr :method4
    #
    # @param [Symbol] symbol
    # @param [Hash] options
    #
    # @return [Hash]
    def xml_attr(symbol, options = {})
      attr = xml_attributes[symbol]
      fail "This xml_attr has already been defined #{symbol}" if attr
      xml_attributes[symbol] = options
    end
  end
end
