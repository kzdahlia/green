# encoding: utf-8
module ApplicationHelper
  def foto_file_path(foto)
    foto.has_thumb? ? foto.url_thumb : user_foto_path(foto.user, foto, :format => :jpg)
  end
end
