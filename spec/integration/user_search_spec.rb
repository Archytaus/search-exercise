describe 'User Search' do
  let(:entity_store) { EntityStore.new([], [], users) }
  let(:search_engine) { SearchEngine.new(entity_store) }
  let(:empty_user_results) { user_results([]) }

  def user_results(results)
    { results: results, entity: :users }
  end

  def search(property, value)
    SearchCommand.new(:users, property, value).execute(search_engine)
  end

  context 'string matching' do
    let(:full_text_record) { { '_id' => '1', 'name' => 'John Smith' } }
    let(:empty_record) { { '_id' => '2', 'name' => '' } }
    let(:users) { [full_text_record, empty_record] }

    it 'matches on full text' do
      expect(search('name', 'John Smith')).to have_attributes user_results([full_text_record])
    end

    it 'does not match partial text' do
      expect(search('name', 'John')).to have_attributes empty_user_results
    end

    it 'matches on empty strings' do
      expect(search('name', '')).to have_attributes user_results([empty_record])
    end
  end

  context 'array matching' do
    let(:full_text_record) { { '_id' => '1', 'tags' => ['For Discussion'] } }
    let(:empty_record) { { '_id' => '2', 'tags' => [''] } }
    let(:nested_full_text_record) { { '_id' => '3', something_else: { 'tags' => ['Feature Request'] } } }
    let(:users) { [full_text_record, empty_record] }

    it 'matches on full text in an element' do
      expect(search('tags', 'For Discussion')).to have_attributes user_results([full_text_record])
    end

    it 'does not match partial text in an element' do
      expect(search('tags', 'Discussion')).to have_attributes empty_user_results
    end

    it 'matches on empty strings in an element' do
      expect(search('tags', '')).to have_attributes user_results([empty_record])
    end

    it 'does not match deeply' do
      expect(search('tags', 'Feature Request')).to have_attributes empty_user_results
    end
  end

  context 'boolean matching' do
    let(:true_record)  { { '_id' => '1', 'active' => true } }
    let(:false_record) { { '_id' => '2', 'active' => false } }
    let(:users) { [true_record, false_record] }

    it 'matches on true values' do
      expect(search('active', true)).to have_attributes user_results([true_record])
    end

    it 'matches on false values' do
      expect(search('active', false)).to have_attributes user_results([false_record])
    end
  end
end
