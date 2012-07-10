class UsersController < ApplicationController
  
  def show
    @fotos = current_user.fotos.enabled
  end
  
  def foto
    foto = Foto.find params[:foto_id]
    response.headers['Content-Type'] = 'image/jpeg'
    render :text => current_user.dropbox_client.thumbnail("Camera%20Uploads/#{foto.filename_origin}", 'large')
  end
  
  def dropbox
    current_user.init_dropbox_url
    current_user.parse_dropbox_photos
    current_user.fotos.enabled.be_queue.each{ |foto| foto.fetch_async }
    redirect_to user_fotos_path(current_user)
  end
end
