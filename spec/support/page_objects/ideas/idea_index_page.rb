class IdeaIndexPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  attr_reader :title

  def initialize
    @page_url = ideas_path
    @title = "Ideas"

    @sign_out_button =        ".sign_out"
    @new_idea_button =        ".new_idea"

    @upvote_button_prefix =   ".upvote, .upvote-"
    @downvote_button_prefix = ".downvote, .downvote-"
  end

  def visit_page
    visit @page_url
  end

  def visit_page_as(user)
    user.present? ? login_as(user) : logout
    visit @page_url
  end


  #Sign out button
  def has_sign_out_button?
    has_css? @sign_out_button
  end

  def click_sign_out_button
    find(@sign_out_button).click
  end


  #New Idea button
  def click_new_idea_button
    find(@new_idea_button).click
  end


  #Upvote buttons
  def upvote_button_for(idea)
    @upvote_button_prefix + idea.id.to_s
  end

  def click_upvote_button_for(idea)
    find(upvote_button_for(idea)).click
  end


  #Downvote buttons
  def downvote_button_for(idea)
    @downvote_button_prefix + idea.id.to_s
  end

  def click_downvote_button_for(idea)
    find(downvote_button_for(idea)).click
  end
end
