class IdeaIndexPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  attr_reader :title

  def initialize
    @page_url = ideas_path
    @title = "Ideas"

    @sign_out_button =                ".sign_out"
    @new_idea_button =                ".new_idea"

    @vote_tally_prefix =              ".votes.votes-"
    @upvote_button_prefix =           ".upvote.upvote-"
    @selected_upvote_button_prefix =  ".selected#{@upvote_button_prefix}"
    @downvote_button_prefix =         ".downvote.downvote-"
    @selected_downvote_button_prefix = ".selected#{@downvote_button_prefix}"
    @detail_link_prefix =             ".idea.idea-"
    @category_button_prefix =         ".category.category-"
    @all_categories_button =          "#{@category_button_prefix}all"
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


  #Vote tally
  def vote_tally_for(idea)
    find(@vote_tally_prefix + idea.id.to_s).text
  end


  #Upvote buttons
  def upvote_button_for(idea)
    @upvote_button_prefix + idea.id.to_s
  end

  def click_upvote_button_for(idea)
    find(upvote_button_for(idea)).click
  end

  def has_selected_upvote_button_for?(idea)
    has_css? @selected_upvote_button_prefix + idea.id.to_s
  end


  #Downvote buttons
  def downvote_button_for(idea)
    @downvote_button_prefix + idea.id.to_s
  end

  def click_downvote_button_for(idea)
    find(downvote_button_for(idea)).click
  end

  def has_selected_downvote_button_for?(idea)
    has_css? @selected_downvote_button_prefix + idea.id.to_s
  end


  def has_detail_link_for?(idea)
    has_css? @detail_link_prefix + idea.id.to_s
  end


  def click_all_categories_button
    find(@all_categories_button).click
  end

  def click_category_button(category)
    find(category_button_for(category)).click
  end

  def category_button_for(category)
    @category_button_prefix + category.id
  end
end
