class UserEditPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  attr_reader :title

  def initialize(user)
    @user =                         user
    @page_url =                     edit_user_path user
    @title =                        "Profile"

    @username_input =               "#user_username"
    @password_input =               "#user_current_password"
    @save_button =                  ".save_user"

    @activate_gold_status_link =    ".activate_gold_status"
  end

  def visit_page
    visit @page_url
  end

  def visit_page_as(user)
    user.present? ? login_as(user) : logout
    visit @page_url
  end

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Form filling
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def fill_username_input_with(username)
    find(@username_input).set username
  end

  def fill_password_input_with(password)
    find(@password_input).set password
  end

  def click_save_button
    find(@save_button).click
  end

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Links
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def has_activate_gold_status_link?
    has_css? @activate_gold_status_link
  end

  def click_activate_gold_status_link
    find(@activate_gold_status_link).click
  end
end
