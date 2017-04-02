class SearchCommand
  attr_reader :entity_type, :property, :value

  def initialize(entity_type, property, value)
    @entity_type = entity_type
    @property = property
    @value = value
  end

  def execute(search_engine)
    search_engine.find(@entity_type, @property, @value)
  end
end
