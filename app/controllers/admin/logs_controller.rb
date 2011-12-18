class Admin::LogsController < ApplicationController
  before_filter :admin_needed

  def index
    @logs=Log.all.order_by([:created_at,:desc])
  end

end
