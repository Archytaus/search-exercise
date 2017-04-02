class SearchResults
  attr_reader :results, :entity

  def initialize(results, entity)
    @results = results
    @entity = entity
  end
end
