class Admin::CommentsController < ApplicationController

  def index
    @comments=Comment.all.order_by([:created_at, :desc]).paginate :page=>params[:page],:per_page=>20
    @count=Comment.count

    
  end

  def destroy
    @comment=Comment.find(params[:id])
    @comment.destroy
    redirect_to :back
  end

end
