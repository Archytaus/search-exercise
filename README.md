# Coding Exercise

## Usage

Assuming you have Ruby installed, and the [bundler gem](http://bundler.io/).

```bash
bundle install
ruby bin/cli.rb
```

Some example commands which can be run:

`users where name = Rose Newton`

`tickets where tags = Ohio`

`organizations where shared_tickets = true`

`tickets where description = `

### Example Output:

```
Loading data files...

Type to execute search commands
Examples:
- `users where name = Rose Newton`
- `tickets where tags = Ohio`
- `organizations where shared_tickets = true`
- `tickets where description = `

Press [Enter] to exit the program.

> organizations where shared_tickets = true
--------------
Found 10 organizations in 0.016 ms:
--------------
  _id: 107
  url: http://initech.zendesk.com/api/v2/organizations/107.json
  external_id: 773cc8fd-12e6-4f0b-9709-a370d98ee2e0
  name: Sulfax
  domain_names: ["comvey.com", "quantalia.com", "velity.com", "enormo.com"]
  created_at: 2016-01-12T01:16:06 -11:00
  details: MegaCörp
  shared_tickets: true
  tags: ["Travis", "Clarke", "Glenn", "Santos"]

  _id: 110
  url: http://initech.zendesk.com/api/v2/organizations/110.json
  external_id: 197f93c0-1729-4c82-9bb0-143e978f06ce
  name: Kindaloo
  domain_names: ["translink.com", "netropic.com", "earthplex.com", "zilencio.com"]
  created_at: 2016-03-15T03:08:47 -11:00
  details: Non profit
  shared_tickets: true
  tags: ["Chen", "Melton", "Stafford", "Landry"]

  <More Results Omitted>
```

### Running Tests

```bash
rspec
```

## Implementation Decisions

- Using an in memory store for the json data for simplicity.

- Searching works by storing all properties and values into a hash so that searching is reduced to a series of hash lookups.

  This gives searching an O(1) complexity, at the expense of more memory overhead.

  This approach is inflexible to change for partial matches, but replacing the `SearchEngine` implementation with one that does partial matches should incur minor changes in other classes.

## Performance Improvements

- To accommodate for larger data sets it would help to save the `EntityStore` to disk, or turn it into a client for a database engine.

This should dramatically reduce memory required to run the application.

## Desired Changes

If this code was to be used in the real world under real world conditions my approach would be a bit different if I knew more about the context the application would be running in.

Some changes that I would make if this was a more critical application:
- Store the ingested data in a database rather than in memory.

  I could then encapsulate the data entities into Models utilizing ActiveRecord (e.g. `User`, `Ticket`, `Organization`).

  This would effectively remove the need for the `EntityStore` class.
- Use a more suitable search engine, rather than a hand written one (e.g. ElasticSearch, or Solr)

- Verify the ingested input against an expected schema

## Assumptions

- > "simple command line application"

  A REPL-like application is acceptable, rather than just a single command that executes and immediately returns

- > "The user should be able to search on any field"

  Assuming the user is searching for a specific field on either the users, tickets, or organization entities; instead of searching for any field.

- Input JSON is valid, uses a consistent schema and all data is considered valid

- Searching is case sensitive
