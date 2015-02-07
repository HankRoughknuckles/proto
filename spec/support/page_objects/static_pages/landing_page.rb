class LandingPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  attr_reader :title

  def initialize
    @page_url = root_path
    @title =                      "Proto"
    @sign_in_page_title =         "Sign in"
    @sign_in_link =               "a.sign_in"
    @signup_form =                "form.new_user"
  end

  def visit_page
    visit @page_url
  end
 
  def visit_page_as(user)
    user.present? ? login_as(user) : logout
    visit @page_url
  end

  def has_proper_title?
    has_title? @title
  end

  def has_signup_form?
    has_css? @signup_form
  end

  def has_sign_in_page_title?
    has_title? @sign_in_page_title
  end

  def click_sign_in_link
    page.find(@sign_in_link).click
  end
end
