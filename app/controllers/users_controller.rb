class UsersController < ApplicationController
  before_action :set_user,      except:   [:add_gold_status]
  before_action :correct_user,  only:     [:edit, :update]

  #PUT /add_gold_status
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


  def show
    
  end


  # GET /users/edit
  def edit
  end


  def update
    @user.assign_attributes user_params

    respond_to do |format|
      if @user.save
        format.html { redirect_to ideas_path, notice: 'Your profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    def user_params
      params.require(:user).permit(:username, :profile_picture)
    end


    def set_user
      @user = User.find params[:id]
    end


    def correct_user
      if current_user.nil? 
        redirect_to new_user_registration_path
      elsif current_user.id != @user.id
        redirect_to root_path
      end
    end
end
