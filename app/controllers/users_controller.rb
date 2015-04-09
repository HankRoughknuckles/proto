class UsersController < ApplicationController

  def add_gold_status
    if User.give_gold_status_to current_user
      flash[:notice] = "Congratulations! You now have gold status!"
      redirect_to edit_user_registration_path current_user

    else

      if current_user.nil?
        flash[:alert] = "You must be logged in to do that"
      else
        current_user.errors.full_messages.each do |message|
          flash[:alert] = message
        end
      end
      redirect_to edit_user_registration_path current_user
    end
  end
end
