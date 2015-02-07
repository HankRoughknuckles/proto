class StaticPagesController < ApplicationController
  def landing_page
    if user_signed_in?
      redirect_to ideas_path
    end
  end
end
