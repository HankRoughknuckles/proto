class StaticPagesController < ApplicationController
  def landing_page
    redirect_to ideas_path if user_signed_in?
  end
end
