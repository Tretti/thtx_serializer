# encoding: utf-8
module THTXSerializer
  # Contains the instance methods that are appended to a class that includes
  # the Serializer.
  #
  # Be careful not to overwrite these methods with your own, as it will impede
  # the functionality of the Serializer.
  #
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
