class EditIdeaPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  attr_reader :title

  def initialize(idea)
    @idea =             idea
    @page_url =         edit_idea_path idea
    @title =            "Edit Idea"
  end

  def visit_page
    visit @page_url
  end

  def visit_page_as(user)
    user.present? ? login_as(user) : logout
    visit @page_url
  end
end
