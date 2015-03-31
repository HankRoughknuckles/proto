class EmailListPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  attr_reader :title

  def initialize(idea)
    @idea =                 idea
    @page_url =             email_list_idea_path(idea)
    @title =                "Subscribers for #{idea.title}"
    @subscriber_amount =    ".subscriber_amount"
  end

  def visit_page
    visit @page_url
  end

  def visit_page_as(user)
    user.present? ? login_as(user) : logout
    visit @page_url
  end

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Subscribers
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def has_subscriber?(user)
    has_text? user.email
  end

  def has_number_of_subscribers_as?(amount)
    has_css? @subscriber_amount, text: amount
  end
end
