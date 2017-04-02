require 'json'

# Ingest + Store
puts "Ingesting"

class EntityStore
  attr_accessor :organizations, :tickets, :users

  def load
    @organizations = JSON.parse(File.read('./data/organizations.json'))
    @tickets = JSON.parse(File.read('./data/tickets.json'))
    @users = JSON.parse(File.read('./data/users.json'))
  end
end

class SearchEngine
  def initialize(entity_store)
    @entity_store = entity_store
  end

  def find(entity_type, field, value)
    matches = []
    @entity_store.send(entity_type.to_sym).each do |e|
      if e[field] == value # TODO case insensitive?
        matches << e
      end
    end

    matches
  end
end

class SearchCommand
  def initialize(entity_type, field, value)
    @entity_type = entity_type
    @field = field
    @value = value
  end

  def self.parse(input_str)
    # TODO Move into a search command parser
    match = /^(?<entity_type>(user|ticket|org)) (?<field>\w+): (?<value>.*)$/.match(input_str)
    return nil if match.nil?

    entity_type_map = {
      user: :users,
      ticket: :tickets,
      org: :organizations
    }
    entity_type = entity_type_map[match[:entity_type].to_sym]
    field = match[:field]
    value = match[:value]

    SearchCommand.new(entity_type, field, value)
  end

  def execute(search_engine)
    search_engine.find(@entity_type, @field, @value)
  end
end

# Index
puts "Indexing"

# CLI GO GO
puts "Ready to accept commands...."
puts "E.g. `user name: Rose Newton`"

entity_store = EntityStore.new
entity_store.load

search_engine = SearchEngine.new(entity_store)

while command_str = gets do
  break if command_str.chomp.length == 0
  puts "received command: #{command_str}"
  command = SearchCommand.parse(command_str)
  if command
    results = command.execute(search_engine)
    puts results.inspect
  else
    puts "Unable to parse command: '#{command_str}'"
  end
end

puts "Exiting. Good night!"
#
