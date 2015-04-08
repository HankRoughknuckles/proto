class UserEditPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  attr_reader :title

  def initialize
    @page_url = edit_user_registration_path
    @title = "Profile"

    @username_input =               "#user_username"
    @password_input =               "#user_current_password"
    @save_button =                  ".save_user"
  end

  def visit_page
    visit @page_url
  end

  def visit_page_as(user)
    user.present? ? login_as(user) : logout
    visit @page_url
  end

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Form filling
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def fill_username_input_with(username)
    find(@username_input).set username
  end

  def fill_password_input_with(password)
    find(@password_input).set password
  end

  def click_save_button
    find(@save_button).click
  end
end
