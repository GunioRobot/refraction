class Admin::CommentsController < ApplicationController
  before_filter :admin_needed
  
  def index
    @comments=Comment.all.order_by([:created_at, :desc]) 
    @count=Comment.count    
  end

  def destroy
    @comment=Comment.find(params[:id])
    Log.new(:from=>current_user,:action=>'rmoved comment: '+@comment.content, :to=>@comment.user).save
    @comment.destroy
    redirect_to :back
  end

end
