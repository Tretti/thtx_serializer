# To Hash To XML Serializer

A small library to build an XML-document from an internal Hash representation of the Object.

It is still in the early process of being developed, but it does work well enough for our internal use.

Inspiration was taken from the ROXML library.

## Example Usage

```ruby
class Example
  include THTXSerializer
  xml_options human_readable: true

  xml_attr :method, { into: :first, in: :in_first }
  xml_attr :method2, { into: :second }
  xml_attr :method3, { in: :in_second }
  xml_attr :method4

  def method; "Foo"; end
  alias :method2 :method
  alias :method3 :method
  alias :method4 :method
end

Example.new.as_xml

# => <?xml version=\"1.0\"?>
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
```

## xml_options

### Accepted parameters

- `:human_readable` - Boolean
- `:root_node` - Symbol define a root node when there is none.
- `:namespace_definitions` - Hash define keys that you need to add to the root node.

- `:key_converter` - Choices are the following:
```ruby
  :lower_camelcase
  :camelcase
  :upcase
  :none
```

Usage:

```ruby
xml_options human_readable: true, root_node: :some_node_name, namespace_definition: {
  "xmlns:integration" => "http://schemas.example.com/integration/0.1/",
  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
  "xsi:schemaLocation" => "http://schemas.example.com/integration/0.1/integration.xsd"
}
```

## xml_attr

Options:
- `:in` - When defined it will wrap the result of the method in a new hash.
- `:into` - When defined it will rewrite the name of the node in the hash.

Usage:

```ruby
xml_attr :a_node

# =>
#<a_node>Some string</a_node>

xml_attr :a_node, { into: :new_node }

# =>
#<new_node>Some string</new_node>

xml_attr :a_node, { in: :in_node }

# =>
#<in_node>
#  <a_node>Some string</a_node>
#</in_node>

xml_attr :a_node, { in: :in_node, into: :new_node }

# =>
#<in_node>
#  <new_node>Some string</new_node>
#</in_node>
```

## Todo

Oh sooo much!

But to start:
- A replacement of Nokogiri and Gyoku with [Builder](https://github.com/jimweirich/builder).
- Extracting a class from Hasher.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Do not change version number or CHANGELOG.
