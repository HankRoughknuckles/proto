class CommentsController < ApplicationController
  def create
    @idea = Idea.find(params[:idea_id])
    @comment = Comment.build_from( @idea, current_user.id, params[:comment][:body])

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @idea, notice: "Comment submitted" }
        format.json { render :show, status: :created, location: @idea }
      else
        format.html { render :new }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end
end
