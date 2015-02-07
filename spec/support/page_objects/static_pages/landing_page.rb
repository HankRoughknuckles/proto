class LandingPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  attr_reader :title

  def initialize
    @page_url = root_path
    @title =            "Proto"
    @signup_form =      "form.new_user"
    @sign_in_link =     "a.sign_in"
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

  def has_sign_in_link?
    has_css? @sign_in_link
  end
end
