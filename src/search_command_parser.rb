class SearchCommandParser
  def self.parse(input_str)
    match = /^(?<entity_type>(users|tickets|organizations)) where (?<property>\w+) =\s?(?<value>.*)$/.match(input_str)
    return nil if match.nil?

    entity_type = match[:entity_type].to_sym
    property = match[:property]
    value = match[:value].strip

    # Convert to boolean
    value = true if value == 'true'
    value = false if value == 'false'

    SearchCommand.new(entity_type, property, value)
  end
end
