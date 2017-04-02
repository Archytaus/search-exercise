describe SearchEngine do
  let(:entity_store) { double(:entity_store) }
  let(:entities) { [] }
  let(:found_entities) { double(:found_entities) }

  subject { SearchEngine.new(entity_store) }

  before do
    allow(entity_store).to receive(:users).and_return(entities)
    allow(entity_store).to receive(:tickets).and_return([])
    allow(entity_store).to receive(:organizations).and_return([])

    allow(entity_store).to receive(:find_all_by_id).and_return(found_entities)
  end

  describe '#find' do
    context 'property equality' do
      let(:matching_entity) { { '_id' => '1', 'test_property' => 'matching value' } }
      let(:not_matching_entity) { { '_id' => '2', 'test_property' => 'a different value' } }
      let(:entities) { [matching_entity, not_matching_entity] }

      context 'matching value' do
        before do
          @search_results = subject.find('users', 'test_property', 'matching value')
        end

        it 'retrieves by id from the entity store' do
          expect(entity_store).to have_received(:find_all_by_id).with('users', ['1'])
        end

        it 'returns search results' do
          expect(@search_results).to have_attributes(results: found_entities, entity: 'users')
        end
      end

      context 'no matching value' do
        before do
          @search_results = subject.find('users', 'test_property', 'not matching value')
        end

        it 'retrieves by id from the entity store' do
          expect(entity_store).to have_received(:find_all_by_id).with('users', [])
        end

        it 'returns empty results' do
          expect(@search_results).to have_attributes(results: found_entities, entity: 'users')
        end
      end
    end

    context 'property array inclusion' do
      let(:matching_entity) { { '_id' => '1', 'test_property' => ['matching element', 'another element'] } }
      let(:not_matching_entity) { { '_id' => '2', 'test_property' => ['a different element', 'another element'] } }
      let(:entities) { [matching_entity, not_matching_entity] }

      context 'matching element' do
        before do
          @search_results = subject.find('users', 'test_property', 'matching element')
        end

        it 'retrieves by id from the entity store' do
          expect(entity_store).to have_received(:find_all_by_id).with('users', ['1'])
        end

        it 'returns search results' do
          expect(@search_results).to have_attributes(results: found_entities, entity: 'users')
        end
      end

      context 'no matching element' do
        before do
          @search_results = subject.find('users', 'test_property', 'not matching element')
        end

        it 'retrieves by id from the entity store' do
          expect(entity_store).to have_received(:find_all_by_id).with('users', [])
        end

        it 'returns empty results' do
          expect(@search_results).to have_attributes(results: found_entities, entity: 'users')
        end
      end
    end
  end
end
