class UsersController < ApplicationController
  
  def show
    @fotos = current_user.fotos.enabled
  end
  
  def foto
    foto = Foto.find params[:foto_id]
    response.headers['Content-Type'] = 'image/jpeg'
    render :text => current_user.dropbox_client.thumbnail("Camera%20Uploads/#{foto.filename}", 'large')
  end
end
