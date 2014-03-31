# Change log

## 0.1.1
- Add support for singularize for collection nodes.

  This means the following is possible without using :into
  ```ruby
  xml_attr :some_nodes # a collection.
  ```

  ```xml
  <some_nodes><some_node></some_node></some_nodes
  ```

## 0.1.0
- Better options handling in hasher.
- Now able to handle empty singular nodes.

## 0.0.3
- No major API changes, extraction of classes and cleaning of specs.
- Now at full code coverage.

## 0.0.2
- No real api changes, just some minor improvements to the code.

## 0.0.1
- First release
