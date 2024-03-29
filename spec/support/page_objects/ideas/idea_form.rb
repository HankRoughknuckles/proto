class IdeaForm
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  attr_reader :title

  def initialize
    # @page_url = path_to_page
    @title = "page_title"
    @title_input =              "#idea_title"
    @description_input =        "#idea_description"
    @youtube_link_input =       "#idea_youtube_link"
    # @category_input =           "#idea_category"
    @summary_input =            "#idea_summary"
    @preferred_checkbox =       "#idea_preferred"
    @submit_button =            "input[type=submit]"
    @error =                    "#error_explanation"
  end

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Inputs
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def fill_form_with(attributes)
    fill_title_input_with         attributes["title"]
    fill_description_input_with   attributes["description"]
    fill_summary_input_with       attributes["summary"]
    # fill_youtube_link_with        attributes["youtube_link"]
    # fill_category_input_with      attributes[:category]
  end

  def fill_title_input_with(title)
    find(@title_input).set title
  end

  def fill_description_input_with(description)
    find(@description_input).set description
  end

  # def fill_category_input_with(category)
  #   find(@category_input).set category
  # end

  def fill_summary_input_with(summary)
    find(@summary_input).set summary
  end

  def fill_youtube_link_with(url)
    find(@youtube_link_input).set url
  end

  def click_submit_button
    find(@submit_button).click
  end

  def has_preferred_checkbox?
    has_css? @preferred_checkbox
  end

  def set_preferred_checkbox(value)
    find(@preferred_checkbox).set value
  end

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Error messages
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def has_title_missing_error?
    has_css? @error, text: "Title"
  end


  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  #%% Finders for contents
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  def has_image_for?(idea)
    has_css? "img[src=\"#{idea.main_image.url(:medium)}\"]"
  end
end
