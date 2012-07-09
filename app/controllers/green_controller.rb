class GreenController < ApplicationController
  def show
    redirect_to user_fotos_path(current_user) if user_signed_in?
  end
end
