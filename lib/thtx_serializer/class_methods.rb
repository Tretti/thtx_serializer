module THTXSerializer
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
      { root_node: self.name.downcase.to_sym }
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
      attr = self.xml_attributes[symbol]
      fail "This xml_attr has already been defined #{symbol}" if attr
      self.xml_attributes[symbol] = options
    end
  end
end
