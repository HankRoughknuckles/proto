class CommentsController < ApplicationController
  def create
    @idea = Idea.find(params[:idea_id])
    @comment = Comment.build_from( @idea, current_user.id, params[:comment][:body])

    respond_to do |format|
      if @comment.save
        IdeaMailer.new_comment_email(@comment, @idea).deliver_now
        format.html { redirect_to @idea, notice: "Comment submitted" }
        format.json { render :show, status: :created, location: @idea }
      else
        flash[:alert] = "Comment can't be blank"
        format.html { render template: "ideas/show" }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end
end
