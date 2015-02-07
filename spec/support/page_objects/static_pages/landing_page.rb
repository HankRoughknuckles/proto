class LandingPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  attr_reader :title

  def initialize
    @page_url = root_path
    @title =                      "Proto"
    @sign_in_link =               "a.sign_in"
    @signup_form =                "form.new_user"
    @email_input =                "input#user_email"
    @password_input =             "input#user_password"
    @password_confirmation_input =  "input#user_password_confirmation"
    @sign_up_button =             "input[type=submit]"

    @email_error =                "#error_explanation"
    @password_error =             "#error_explanation"
    @icon_link =                  "#icon"
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

  def sign_up_using(inputs)
    page.find(@email_input).set     inputs[:email]
    page.find(@password_input).set  inputs[:password]
    page.find(@password_confirmation_input).set  inputs[:password]
    page.find(@sign_up_button).click
  end

  def has_email_error?
    has_css? @email_error, text: "Email"
  end

  def has_password_error?
    has_css? @password_error, text: "Password"
  end

  def click_icon_link
    find(@icon_link).click
  end
end
