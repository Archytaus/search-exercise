class SearchEngine
  def initialize(entity_store)
    @entity_store = entity_store

    setup_property_lookups
  end

  def find(entity_type, property, value)
    entity_properties = @property_lookup[entity_type.to_sym][property] || {}
    ids = entity_properties[value] || []
    results = @entity_store.find_all_by_id(entity_type, ids)
    SearchResults.new(results, entity_type)
  end

  private

  def setup_property_lookups
    # Optimization only useful for exact search matches
    # Each entity (user, organization, ticket) has a hash for each property
    #  which has every possible value resolving to an array of ids that have
    #  that value for that property.
    #
    # Example:
    #
    #   users:
    #     locale:
    #       en-AU: [1, 3, 7, 10]
    #
    @property_lookup = {}

    %i(users tickets organizations).each do |entity_type|
      @property_lookup[entity_type] = {}
      @entity_store.send(entity_type).each do |entity|
        id = entity['_id']

        entity.each do |property, value|
          property_lookup = @property_lookup[entity_type][property] ||= {}
          if value.is_a?(Array)
            value.each do |value_element|
              occurances = property_lookup[value_element] ||= []
              occurances << id
            end
          else
            occurances = property_lookup[value] ||= []
            occurances << id
          end
        end
      end
    end
  end
end
