class EntityStore
  def initialize(organizations, tickets, users)
    @organizations = {}
    organizations.each do |organization|
      @organizations[organization['_id']] = organization
    end

    @tickets = {}
    tickets.each do |ticket|
      @tickets[ticket['_id']] = ticket
    end

    @users = {}
    users.each do |user|
      @users[user['_id']] = user
    end
  end

  def organizations
    @organizations.values
  end

  def tickets
    @tickets.values
  end

  def users
    @users.values
  end

  def self.load
    begin
      organizations = JSON.parse(File.read('./data/organizations.json'))
    rescue JSON::ParserError => e
      raise "Failed to load './data/organizations.json' due to JSON parse error. #{e.inspect}"
    end

    begin
      tickets = JSON.parse(File.read('./data/tickets.json'))
    rescue JSON::ParserError => e
      raise "Failed to load './data/tickets.json' due to JSON parse error. #{e.inspect}"
    end

    begin
      users = JSON.parse(File.read('./data/users.json'))
    rescue JSON::ParserError => e
      raise "Failed to load './data/users.json' due to JSON parse error. #{e.inspect}"
    end

    EntityStore.new(organizations, tickets, users)
  end

  def find_organization(organization_id)
    @organizations[organization_id]
  end

  def find_user(user_id)
    @users[user_id]
  end

  def find_all_by_id(entity_type, ids)
    case entity_type
    when :users
      ids.map { |id| @users[id] }
    when :organizations
      ids.map { |id| @organizations[id] }
    when :tickets
      ids.map { |id| @tickets[id] }
    end
  end
end
