class LoginPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  attr_reader :title

  def initialize
    @page_url = new_user_session_path
    @title = "Sign in"

    @signup_email_input =               ".signup_email"
    @signup_email_input =               ".signup_password"
    @submit_signup_button =             ".signup_submit"
  end

  def visit_page
    visit @page_url
  end

  def visit_page_as(user)
    user.present? ? login_as(user) : logout
    visit @page_url
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Inputs
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def sign_up_with(attrs)
    find(@signup_email_input).set attrs[:email]
    find(@signup_password_input).set attrs[:email]

    find(@submit_signup_button).click
  end
end
