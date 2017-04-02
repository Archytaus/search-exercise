describe SearchCommandParser do
  context 'invalid command' do
    context 'empty command' do
      it { expect(SearchCommandParser.parse('')).to be_nil }
    end

    context 'unknown entity command' do
      it { expect(SearchCommandParser.parse('assignees where name = hello')).to be_nil }
    end

    context 'malformed command' do
      it { expect(SearchCommandParser.parse('users where name hello')).to be_nil }
    end
  end

  context 'parsing valid command' do
    shared_context 'parses command' do
      it { expect(SearchCommandParser.parse(command_str)).to have_attributes(expected_command) }
    end

    context 'users' do
      let(:command_str) { 'users where name = hello' }
      let(:expected_command) { { entity_type: :users, property: 'name', value: 'hello' } }

      include_context 'parses command'
    end

    context 'organizations' do
      let(:command_str) { 'organizations where name = hello' }
      let(:expected_command) { { entity_type: :organizations, property: 'name', value: 'hello' } }

      include_context 'parses command'
    end

    context 'tickets' do
      let(:command_str) { 'tickets where name = hello' }
      let(:expected_command) { { entity_type: :tickets, property: 'name', value: 'hello' } }

      include_context 'parses command'
    end

    context 'empty value' do
      context 'whitespace' do
        let(:command_str) { 'users where name =  ' }
        let(:expected_command) { { entity_type: :users, property: 'name', value: '' } }

        include_context 'parses command'
      end

      context 'no value provided' do
        let(:command_str) { 'users where name =' }
        let(:expected_command) { { entity_type: :users, property: 'name', value: '' } }

        include_context 'parses command'
      end
    end

    context 'boolean value' do
      context 'true value' do
        let(:command_str) { 'users where name = true' }
        let(:expected_command) { { entity_type: :users, property: 'name', value: true } }

        include_context 'parses command'
      end

      context 'false value' do
        let(:command_str) { 'users where name = false' }
        let(:expected_command) { { entity_type: :users, property: 'name', value: false } }

        include_context 'parses command'
      end
    end
  end
end
