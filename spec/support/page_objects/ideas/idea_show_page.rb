class IdeaShowPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  attr_reader :title

  def initialize(idea)
    @idea =                         idea
    @page_url =                     idea_path idea
    @title =                        "page_title"

    @profile_link_prefix =          ".user_"
    @link_to_owners_profile =       ".owner_profile"
    @vote_tally_prefix =            ".votes.votes-"
    @upvote_button =                ".upvote"
    @downvote_button =              ".downvote"
    @subscribe_button =             ".subscribe"
    @email_list_button =            ".list_emails"
    @add_comment_button =           ".add_comment"
    @comment_form =                 "#comment_body"
    @listed_comment =               ".comment"
    @submit_comment_button =        'form.new_comment input[type="submit"]'

    @next_idea_link =               ".next_idea"
    @previous_idea_link =           ".previous_idea"

    @edit_idea_link =               '.edit_idea'
    @delete_idea_link =             '.delete_idea'

    @alert_flash_message =          ".alert"

    # Social buttons
    @facebook_share_button =        ".facebook_share"
  end

  def visit_page
    visit @page_url
  end

  def visit_page_as(user)
    user.present? ? login_as(user) : logout
    visit @page_url
  end

  def image_with_src(src)
    "img[src=\"#{src}\"]"
  end

  def has_main_image?
    has_css? image_with_src @idea.main_image.url(:poster)
  end

  def has_vote_tally?
    has_css?(@vote_tally_prefix + @idea.id.to_s, text: @idea.vote_tally)
  end

  def youtube_video_with_address(url)
    "iframe[src=\"#{url}\"]"
  end

  def has_youtube_video_with_address?(url)
    has_css? youtube_video_with_address url
  end

  def has_link_to_owners_profile?
    has_css? @link_to_owners_profile
  end

  def has_a_link_to_profile_of? user
    has_css? link_to_profile_of user
  end

  def link_to_profile_of(user)
    @profile_link_prefix + user.id.to_s
  end

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Next / previous links
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def click_next_idea_link
    find(@next_idea_link).click
  end


  def click_previous_idea_link
    find(@previous_idea_link).click
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% The vote buttons
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def click_upvote_button
    find(@upvote_button).click
  end

  def click_downvote_button
    find(@downvote_button).click
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% The email buttons
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def has_subscribe_button?
    has_css? @subscribe_button
  end

  def click_subscribe_button
    find(@subscribe_button).click
  end

  def has_email_list_button?
    has_css? @email_list_button
  end

  def click_email_list_button
    find(@email_list_button).click
  end

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% The comment elements
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def has_add_comment_button?
    has_css? @add_comment_button
  end

  def has_a_comment_form?
    has_css? @comment_form
  end

  def fill_comment_form_with(input)
    find(@comment_form).set input
  end

  def click_submit_comment_button
    find(@submit_comment_button).click
  end

  def has_a_comment_with_text?(text)
    has_css? @listed_comment, text: text
  end

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Edit / Destroy buttons
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def has_edit_idea_link?
    has_css? @edit_idea_link
  end

  def has_delete_idea_link?
    has_css? @delete_idea_link
  end

  def click_delete_idea_link
    find(@delete_idea_link).click
  end


  def has_alert_flash_message?
    has_css? @alert_flash_message
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Social networking buttons
  ##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def has_facebook_share_button?
    has_css? @facebook_share_button
  end
end
