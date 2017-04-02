class TicketsPresenter
  def initialize(tickets, entity_store)
    @tickets = tickets
    @entity_store = entity_store
  end

  def to_s(indent_level = 2)
    @tickets.map { |ticket| format_ticket(ticket) }
           .join("\n\n")
           .indent(indent_level)
  end

  private

  def format_ticket(ticket)
    ticket.map { |property, value| format_property(property, value) }
          .join("\n")
  end

  def format_property(property, value)
    case property
    when 'submitter_id'
      user = @entity_store.find_user(value)
      "submitter:\n" + format_ticket_user(user)
    when 'assignee_id'
      user = @entity_store.find_user(value)
      "assignee:\n" + format_ticket_user(user)
    when 'organization_id'
      organization = @entity_store.find_organization(value)
      "organization:\n" + format_ticket_organization(organization)
    else
      "#{property}: #{value}"
    end
  end

  def format_ticket_user(user)
    if user
      UsersPresenter.new([user], @entity_store).to_s
    else
      "  >> Unable to find User(#{value})"
    end
  end

  def format_ticket_organization(organization)
    if organization
      OrganizationsPresenter.new([organization], @entity_store).to_s
    else
      "  >> Unable to find Organizations(#{value})"
    end
  end
end
