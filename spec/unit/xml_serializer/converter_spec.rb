describe 'Converter' do
  subject { THTXSerializer::Converter }

  context '#to_xml' do
    context 'given a plain hash' do
      it 'will transform into a xml-string' do
        xml = subject.to_xml({ one: { two: 1, three: 2 } })

        expected = "<one><two>1</two><three>2</three></one>"

        expect(xml).to eq expected
      end
    end

    context 'given a nested hash' do
      it 'will transform into a xml-string' do
        xml = subject.to_xml({ one: { two: 1, three: { four: 3 } } })

        expected = "<one><two>1</two><three><four>3</four></three></one>"

        expect(xml).to eq expected
      end
    end

    context 'given no :key_converter setting is provided' do
      it 'will not manipulate the keys' do
        xml = subject.to_xml({ one: { one_one: 1, 'two-two' => { three: 3 } } })

        expected = "<one><one_one>1</one_one><two-two><three>3</three></two-two></one>"

        expect(xml).to eq expected
      end
    end

    context 'given a :key_converter setting is provided' do
      it 'will manipulate the keys accordingly' do
        xml = subject.to_xml({ one: { one_one: 1, two_two: { three: 3 } } },
          key_converter: :camelcase)

        expected = "<One><OneOne>1</OneOne><TwoTwo><Three>3</Three></TwoTwo></One>"

        expect(xml).to eq expected
      end
    end

    context 'given a :namespace option is provided' do
      it 'will be able to handle a namespace option' do
        xml = subject.to_xml({one: { two: 1, three: 2 }}, namespace: 'integration' )

        expected = "<integration:one><integration:two>1</integration:two><integration:three>2</integration:three></integration:one>"

        expect(xml).to eq expected
      end
    end

    context 'given the option :namespace_definitions has been set' do
      it 'will be able to extract namespace_definitions and apply them to the xml' do
        xml = subject.to_xml({one: { two: 1, three: 2 }},
          namespace_definitions: { 'melons:test' => 'string'})

        expected = "<one melons:test=\"string\"><two>1</two><three>2</three></one>"

        expect(xml).to eq expected
      end
    end

    context 'given the option :human_readable' do
      it 'will massage an xml-string into a human readable string' do
        xml = subject.to_xml({one: { two: 1, three: 2 }},
          namespace_definitions: { 'xmlns:test' => 'string'}, human_readable: true)

        expected = "<?xml version=\"1.0\"?>\n<one xmlns:test=\"string\">\n  <two>1</two>\n  <three>2</three>\n</one>\n"

        expect(xml).to eq expected
      end
    end
  end
end
