class FotosController < ApplicationController
  before_filter :load_foto_ids, :only => [ :destroy_collection, :update_collection ]
  
  def index
    @fotos = current_user.fotos.enabled.page(params[:page]).per(30)
    if params[:tag_id]
      @tag = Tag.find(params[:tag_id])
      @fotos = @fotos.where(:id => @tag.fotos.map(&:id)) 
    elsif params[:untagging]
      @fotos = @fotos.where(:taggings_count => 0) 
    end
  end
  
  def show
    @foto = current_user.fotos.find params[:id]
    if params[:format] == 'jpg'
      response.headers['Content-Type'] = 'image/jpeg'
      render :text => current_user.dropbox_client.thumbnail("Camera%20Uploads/#{@foto.filename_origin}", 'large')
    end
  end
  
  def update
    @foto = current_user.fotos.find params[:id]
    if @foto.update_attributes params[:foto]
      redirect_to request.env["HTTP_REFERER"] || user_fotos_path(current_user)
    end
  end
  
  def destroy_collection
    current_user.fotos.where(:id => @foto_ids).each do |foto|
      foto.disable
    end
    redirect_to user_fotos_path(current_user)
  end
  
  def update_collection
    append_tags(@foto_ids) if params[:foto] && (params[:foto][:tag_ids] || []).size > 0
    redirect_to user_fotos_path(current_user)
  end
  
  def destroy
    @foto = current_user.fotos.find params[:id]
    @foto.disable
    redirect_to(@foto.prev ? user_foto_path(current_user, @foto.prev) : user_fotos_path(current_user))
  end
  
  private 
  
  def append_tags(foto_ids)
    current_user.fotos.where(:id => @foto_ids).each do |foto|
      foto.update_attributes :tag_ids => (params[:foto][:tag_ids].map(&:to_i) + foto.tag_ids).uniq
    end
  end
  
  def load_foto_ids
    @foto_ids = params[:user][:fotos_attributes].values.select{ |tmp| tmp[:_id] == "1" }.map{ |tmp| tmp[:id] }
    @foto_ids << 0
  end
  
end
