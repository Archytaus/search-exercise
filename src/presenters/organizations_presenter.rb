class OrganizationsPresenter
  def initialize(organizations, entity_store)
    @organizations = organizations
    @entity_store = entity_store
  end

  def to_s(indent_level = 2)
    @organizations.map { |organization| format_organiation(organization) }
                  .join("\n\n")
                  .indent(indent_level)
  end

  private

  def format_organiation(organization)
    organization.map { |property, value| format_property(property, value) }
                .join("\n")
  end

  def format_property(property, value)
    "#{property}: #{value}"
  end
end
