class TagsController < ApplicationController
  def create
    @tag = current_user.tags.build params[:tag]
    flash[:error] = @tag.errors.full_messages if !@tag.save
    redirect_to request.referer || user_fotos_path(current_user)
  end
end
