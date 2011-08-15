class Admin::CommentsController < ApplicationController

  def index
    @comments=Comment.all.paginate :page=>params[:page],:per_page=>20
    @count=Comment.count

    
  end

  def destroy
    @comment=Comment.find(params[:id])
    @comment.destroy
    redirect_to :back
  end

end
