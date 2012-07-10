class TagsController < ApplicationController
  def create
    @tag = current_user.tags.build params[:tag]
    flash[:error] = @tag.errors.full_messages if !@tag.save
    if params[:format] == "html"
      if flash[:error]
        render :text => ""
      else
        render :show, :layout => false
      end
    else
      redirect_to request.referer || user_fotos_path(current_user)
    end
  end
end
