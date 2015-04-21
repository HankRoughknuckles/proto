class AuthenticationPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  attr_reader :title

  def initialize
    @page_url = new_user_registration_path
    @title = "Authentication"

    @continue_with_facebook_link =      ".continue_with_facebook"

    @signup_email_input =               ".signup_email"
    @signup_password_input =            ".signup_password"
    @submit_signup_button =             ".signup_submit"

    @signin_email_input =               ".signin_email"
    @signin_password_input =            ".signin_password"
    @submit_signin_button =             ".signin_submit"

    @notice_flash =                     ".notice"
    @alert_flash =                      ".alert"
    @error_message =                    "#error_explanation"
  end

  def visit_page
    visit @page_url
  end

  def visit_page_as(user)
    user.present? ? login_as(user) : logout
    visit @page_url
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Facebook link
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def has_continue_with_facebook_link?
    has_css? @continue_with_facebook_link
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Sign Up Inputs
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def fill_signup_inputs_with(attrs)
    fill_signup_email_input_with attrs[:email]
    fill_signup_password_input_with attrs[:password]
  end


  def fill_signup_email_input_with(email)
    find(@signup_email_input).set email
  end


  def fill_signup_password_input_with(password)
    find(@signup_password_input).set password
  end


  def click_signup_submit_button
    find(@submit_signup_button).click
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Sign In (Login) Inputs
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def fill_signin_inputs_with(attrs)
    fill_signin_email_input_with attrs[:email]
    fill_signin_password_input_with attrs[:password]
  end


  def fill_signin_email_input_with(email)
    find(@signin_email_input).set email
  end


  def fill_signin_password_input_with(password)
    find(@signin_password_input).set password
  end


  def click_signin_submit_button
    find(@submit_signin_button).click
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Flash messages
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def has_signup_successful_flash?
    has_css? @notice_flash, text: "Welcome"
  end


  def has_signin_successful_flash?
    has_css? @notice_flash, text: "Signed in successfully"
  end


  def has_missing_email_error?
    has_css? @error_message, text: "Email"
  end


  def has_invalid_email_flash?
    has_css? @alert_flash, text: "email"
  end


  def has_invalid_password_flash?
    has_css? @alert_flash, text: "password"
  end


  def has_missing_password_error?
    has_css? @error_message, text: "Password"
  end
end
