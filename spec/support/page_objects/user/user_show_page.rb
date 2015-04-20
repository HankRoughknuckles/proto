class UserShowPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  attr_reader :title

  def initialize(user)
    @user =                         user
    @page_url =                     user_path(@user)
    @title =                        "Profile - #{user.username}"

    @edit_user_link =               ".edit_user"
    @idea_link_prefix =             "a.idea_"
    @activate_gold_status_link =    ".activate_gold_status"
    @new_idea_link =                ".new_idea"
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

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% edit user link
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def has_edit_user_link?
    has_css? @edit_user_link
  end

  def click_edit_user_link
    find(@edit_user_link).click
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Idea links
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def has_idea_link?(idea)
    has_css? idea_link_for idea
  end

  def idea_link_for(idea)
    @idea_link_prefix + idea.id.to_s
  end

  def has_activate_gold_status_link?
    has_css? @activate_gold_status_link
  end

  def has_a_link_for_making_ideas?
    has_css? @new_idea_link
  end
end
