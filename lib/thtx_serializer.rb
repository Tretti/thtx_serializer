# encoding: utf-8
require 'thtx_serializer/class_methods'
require 'thtx_serializer/converter'
require 'thtx_serializer/hasher'
require 'thtx_serializer/hash_node'
require 'thtx_serializer/instance_methods'

# The module that needs to be included to turn the class at hand into a
# xml serializing daemon.
#
# The top object is in charge of running as_xml, the underlying ones
# will only produce their representation as hashes. Then all is passed off
# to Gyoku in the Converter.
#
# @example
#   class Example
#     include THTXSerializer
#     xml_options human_readable: :true
#
#     xml_attr :method, { into: :first, in: :in_first }
#     xml_attr :method2, { into: :second }
#     xml_attr :method3, { in: :in_second }
#     xml_attr :method4
#
#     def method; "Foo"; end
#     alias :method2 :method
#     alias :method3 :method
#     alias :method4 :method
#   end
#
#   Example.new.as_xml
#
# =>
#    <?xml version=\"1.0\"?>
#    <example>
#      <in_first>
#         <first>Foo</first>
#      </in_first>
#      <second>Foo</second>
#      <in_second>
#        <method3>Foo</method3>
#      </in_second>
#      <method4>Foo</method4>
#    </example>
#
module THTXSerializer
  # Using the included hook to extend and include
  # the instance and class methods.
  #
  # @param [Class] base
  def self.included(base)
    base.class_eval do
      extend ClassMethods
      include InstanceMethods
    end
  end
end
