describe EntityStore do
  describe '#organizations' do
    let(:organizations) { [spy, spy, spy] }
    subject { EntityStore.new(organizations, [], []) }

    it 'returns the organizations' do
      expect(subject.organizations).to eq organizations
    end
  end

  describe '#tickets' do
    let(:tickets) { [spy, spy, spy] }
    subject { EntityStore.new([], tickets, []) }

    it 'returns the tickets' do
      expect(subject.tickets).to eq tickets
    end
  end

  describe '#users' do
    let(:users) { [spy, spy, spy] }
    subject { EntityStore.new([], [], users) }

    it 'returns the users' do
      expect(subject.users).to eq users
    end
  end

  describe '#find_organization' do
    let(:organization_record) { { '_id' => '123456' } }
    let(:organizations) { [organization_record] }
    subject { EntityStore.new(organizations, [], []) }

    it 'can find an organization with a matching id' do
      expect(subject.find_organization('123456')).to be organization_record
    end

    it 'returns nil if there is no matching id' do
      expect(subject.find_organization('098765')).to be_nil
    end
  end

  describe '#find_user' do
    let(:user_record) { { '_id' => '123456' } }
    let(:users) { [user_record] }
    subject { EntityStore.new([], [], users) }

    it 'can find a user with a matching id' do
      expect(subject.find_user('123456')).to be user_record
    end

    it 'returns nil if there is no matching id' do
      expect(subject.find_user('098765')).to be_nil
    end
  end

  describe '#find_all_by_id' do
    context 'users' do
      let(:matching_user) { { '_id' => '123456' } }
      let(:not_matching_user) { { '_id' => '67890' } }

      subject { EntityStore.new([], [], [matching_user, not_matching_user]) }

      it 'matches on id' do
        results = subject.find_all_by_id(:users, ['123456'])
        expect(results).to be_include(matching_user)
      end
    end

    context 'organizations' do
      let(:matching_organization) { { '_id' => '123456' } }
      let(:not_matching_organization) { { '_id' => '67890' } }

      subject { EntityStore.new([matching_organization, not_matching_organization], [], []) }

      it 'matches on id' do
        results = subject.find_all_by_id(:organizations, ['123456'])
        expect(results).to be_include(matching_organization)
      end
    end

    context 'tickets' do
      let(:matching_ticket) { { '_id' => '123456' } }
      let(:not_matching_ticket) { { '_id' => '67890' } }

      subject { EntityStore.new([], [matching_ticket, not_matching_ticket], []) }

      it 'matches on id' do
        results = subject.find_all_by_id(:tickets, ['123456'])
        expect(results).to be_include(matching_ticket)
      end
    end
  end
end
