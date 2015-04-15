class StaticPagesController < ApplicationController

  # GET /
  def landing_page
    if user_signed_in?
      redirect_to ideas_path if user_signed_in?
    else
      redirect_to new_user_registration_path
    end
  end


  # GET /feedback
  def feedback
  end


  # GET /gold_activation
  def gold_activation
  end
end
