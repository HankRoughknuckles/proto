class IdeasController < ApplicationController
  before_action :set_idea, only: [:edit, :update, :destroy,
                                  :upvote, :downvote, :subscribe,
                                  :email_list]
  before_action :authenticate_user!, only: [:upvote, :downvote,
                                            :subscribe, :new]
  before_action :correct_user, only: [:edit, :destroy, :update, :email_list]
  before_action :check_gold_status, only: [:new]

  # GET /ideas
  # GET /ideas/?category=Technology
  # GET /ideas.json
  def index
    # filter the shown ideas by the category in the query string.  If
    # none specified, return all
    category_name = ideas_index_params[:category]
    if category_name.present?
      category = Category.find_by_name category_name
      @ideas = category.ideas
    else
      @ideas = Idea.all.order(hotness: :desc)
    end
  end

  # GET /ideas/1
  # GET /ideas/1.json
  def show
    @ideas = Idea.all.order(hotness: :desc)
    @idea = @ideas.find params[:id]
    # TODO: this index command will get slow as @ideas gets big, fix that
    @index = @ideas.index @idea
    @previous = @index - 1 < 0 ? @ideas.last : @ideas[@index - 1]
    @next = @index + 1 >= @ideas.length ? @ideas.first : @ideas[@index + 1]

    unless current_user.nil?
      @comment = Comment.build_from( @idea, current_user.id, "")
    end
    render :layout => "next_previous"
  end

  # GET /ideas/new
  def new
    @idea = Idea.new
  end

  # GET /ideas/1/edit
  def edit
  end

  # GET /ideas/1/email_list
  def email_list
    @subscribers = @idea.subscribers
  end

  # POST /ideas
  # POST /ideas.json
  def create
    @idea = Idea.new(idea_params)
    @idea.owner = current_user
    @idea.preferred = false unless current_user_has_gold_status?

    respond_to do |format|
      if @idea.save
        IdeaMailer.new_idea_email(@idea).deliver_now
        format.html { redirect_to @idea, notice: 'Your idea is ready to go! Tell your friends and family about it on social media!' }
        format.json { render :show, status: :created, location: @idea }
      else
        format.html { render :new }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ideas/1
  # PATCH/PUT /ideas/1.json
  def update
    @idea.assign_attributes idea_params
    @idea.preferred = false unless current_user_has_gold_status?
    respond_to do |format|
      if @idea.save
        format.html { redirect_to @idea, notice: 'Idea was successfully updated.' }
        format.json { render :show, status: :ok, location: @idea }
      else
        format.html { render :edit }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ideas/1
  # DELETE /ideas/1.json
  def destroy
    @idea.destroy
    respond_to do |format|
      format.html { redirect_to ideas_url, notice: 'Idea was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  # PUT /ideas/1/upvote.json
  def upvote
    @idea.liked_by current_user
    @idea.save
    respond_to do |format|
      format.json { render(text: @idea.vote_tally, 
                           status: :ok, 
                           location: @idea) }
    end
  end

  # PUT /ideas/1/downvote.json
  def downvote
    @idea.disliked_by current_user
    @idea.save
    respond_to do |format|
      format.json { render(text: @idea.vote_tally, 
                           status: :ok, 
                           location: @idea) }
    end
  end


  # POST /ideas/1/subscribe
  def subscribe
    @idea.add_subscriber! current_user
    IdeaMailer.new_subscriber_email(current_user, @idea).deliver_now

    respond_to do |format|
      format.html { redirect_to(@idea, 
                                notice: "You've added your email to the
                                        list.") }
      format.json { render(text: "ok", 
                           status: :created, 
                           location: @idea) }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_idea
      @idea = Idea.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def idea_params
      params.require(:idea).permit(:title, :description, :main_image,
                                   :summary, :youtube_link, :preferred)
    end

    def ideas_index_params
      params.permit(:category)
    end

    def correct_user
      if current_user.nil? 
        redirect_to new_user_registration_path, alert: "Please log in first."
      elsif @idea.owner != current_user
        redirect_to root_path, alert: "Wait a sec, you can't do that!"
      end
    end

    def check_gold_status
      if User.has_expired_gold_status? current_user
        User.take_gold_status_from current_user
      end
    end
end
