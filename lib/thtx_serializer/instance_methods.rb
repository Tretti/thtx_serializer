module THTXSerializer
  module InstanceMethods
    # @return [String]
    def as_xml
      Converter.to_xml(__hash_data__, self.class.xml_options)
    end

    # @return [Hash] All components of the object transformed into a big Hash.
    def __hash_data__
      Hasher.new(self).hash_object
    end
  end
end
