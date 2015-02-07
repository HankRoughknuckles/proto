class IdeaIndexPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  attr_reader :title

  def initialize
    @page_url = ideas_path
    @title = "Ideas"

    @sign_out_button =        ".sign_out"
    @new_idea_button =        ".new_idea"
  end

  def visit_page
    visit @page_url
  end

  def visit_page_as(user)
    user.present? ? login_as(user) : logout
    visit @page_url
  end

  def has_sign_out_button?
    has_css? @sign_out_button
  end

  def click_sign_out_button
    find(@sign_out_button).click
  end

  def click_new_idea_button
    find(@new_idea_button).click
  end
end
