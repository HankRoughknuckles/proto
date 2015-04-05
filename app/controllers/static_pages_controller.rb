class StaticPagesController < ApplicationController

  # GET /
  def landing_page
    redirect_to ideas_path if user_signed_in?
  end


  # GET /feedback
  def feedback
  end
end
