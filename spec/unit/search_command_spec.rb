describe SearchCommand do
  describe '#execute' do
    let(:entity_type) { double(:entity_type) }
    let(:property) { double(:property) }
    let(:value) { double(:value) }
    let(:search_engine) { double(:search_engine) }

    subject { SearchCommand.new(entity_type, property, value) }

    before do
      allow(search_engine).to receive(:find)
    end

    it 'finds using the supplied search engine' do
      subject.execute(search_engine)
      expect(search_engine).to have_received(:find).with(entity_type, property, value)
    end
  end
end
