class FotosController < ApplicationController
  before_filter :load_foto_ids, :only => [ :destroy_collection ]
  
  def index
    @fotos = current_user.fotos.enabled.page(params[:page]).per(10)
  end
  
  def show
    @foto = current_user.fotos.find params[:id]
    response.headers['Content-Type'] = 'image/jpeg'
    render :text => current_user.dropbox_client.thumbnail("Camera%20Uploads/#{@foto.filename}", 'large') if params[:format] == 'jpg'
  end
  
  def update
    @foto = current_user.fotos.find params[:id]
    if @foto.update_attributes params[:foto]
      redirect_to user_fotos_path(current_user)
    end
  end
  
  def destroy_collection
    current_user.fotos.where(:id => @foto_ids).each do |foto|
      foto.disable
    end
    redirect_to user_fotos_path(current_user)
  end
  
  private 
  
  def load_foto_ids
    @foto_ids = params[:user][:fotos_attributes].values.select{ |tmp| tmp[:_id] == "1" }.map{ |tmp| tmp[:id] }
    @foto_ids << 0
  end
  
  
>>>>>>> foto model and collection update
end
