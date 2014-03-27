describe 'Class Methods' do
  describe '.xml_attributes' do
    it 'will hold the defined attributes in an array' do
      class TestClassAttributes
        include THTXSerializer
      end

      klass = TestClassAttributes
      expect(klass.xml_attributes).to eq({})
    end
  end

  describe '.xml_attr' do
    context 'given an attribute is defined' do
      it 'will be added to the list of attributes' do
        class TestClassFirst
          include THTXSerializer
          xml_attr :first
        end

        klass = TestClassFirst
        expect(klass.xml_attributes).to eq(first: {})
      end
    end

    context 'given an attribute has already been defined' do
      it 'will raise an error' do
        class TestClassDuplicate
          include THTXSerializer
          xml_attr :duplicate
        end

        klass = TestClassDuplicate

        expect{ klass.send(:xml_attr, :duplicate) }.to raise_error(RuntimeError)
      end
    end

    context 'given an options hash is given' do
      it 'will be contained inside the list of attributes' do
        class TestClassAs
          include THTXSerializer
          xml_attr :first, { in: :test_key }
        end

        klass = TestClassAs
        expect(klass.xml_attributes).
          to eq(first: { in: :test_key } )
      end
    end
  end
end
