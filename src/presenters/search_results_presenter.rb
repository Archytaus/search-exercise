class SearchResultsPresenter
  ENTITY_PRESENTERS = {
    tickets:       TicketsPresenter,
    users:         UsersPresenter,
    organizations: OrganizationsPresenter
  }.freeze

  def initialize(search_results, entity_store, search_time)
    @search_results = search_results
    @entity_store = entity_store
    @search_time = search_time
  end

  def to_s
    %(
--------------
Found #{@search_results.results.count} #{@search_results.entity} in #{format('%.3f', @search_time * 1000)} ms:
--------------
#{ENTITY_PRESENTERS[@search_results.entity].new(@search_results.results, @entity_store)}
    )
  end
end
