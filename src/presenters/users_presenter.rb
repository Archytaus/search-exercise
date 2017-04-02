class UsersPresenter
  def initialize(users, entity_store)
    @users = users
    @entity_store = entity_store
  end

  def to_s(indent_level = 2)
    @users.map { |user| format_user(user) }
          .join("\n\n")
          .indent(indent_level)
  end

  private

  def format_user(user)
    user.map { |property, value| format_property(property, value) }
        .join("\n")
  end

  def format_property(property, value)
    case property
    when 'organization_id'
      organization = @entity_store.find_organization(value)
      "organization:\n" + format_user_organization(organization)
    else
      "#{property}: #{value}"
    end
  end

  def format_user_organization(organization)
    if organization
      OrganizationsPresenter.new([organization], @entity_store).to_s
    else
      "  >> Unable to find Organizations(#{value})"
    end
  end
end
