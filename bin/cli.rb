require 'json'
require 'benchmark'
require './src/lib'

puts "Loading data files..."
begin
  entity_store = EntityStore.load
rescue StandardError => e
  puts "Encountered an error while starting up: "
  puts e
  exit 1
end

search_engine = SearchEngine.new(entity_store)

# CLI GO GO
print %q(
Type to execute search commands
Examples:
- `users where name = Rose Newton`
- `tickets where tags = Ohio`
- `organizations where shared_tickets = true`
- `tickets where description = `

Press [Enter] to exit the program.

> )

while command_str = gets.chomp
  break if command_str.length.zero?

  command = SearchCommandParser.parse(command_str)
  if command
    results = nil
    before_timestamp = Time.now
    results = command.execute(search_engine)
    after_timestamp = Time.now
    search_time = after_timestamp - before_timestamp
    puts SearchResultsPresenter.new(results, entity_store, search_time).to_s
  else
    puts "Unable to parse command: '#{command_str}'"
  end

  print '> '
end
