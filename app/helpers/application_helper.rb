# encoding: utf-8
module ApplicationHelper
  def foto_file_path(foto)
    foto.has_thumb? ? foto.url_thumb : user_foto_path(foto.user, foto, :format => :jpg)
  end
  
  def foto_checked_number
    raw "<span id='foto_checked'>0</span>"
  end

  def body_classes(append_classes = nil)
    classes = [params[:controller].gsub("/","-"), params[:action]]
    if append_classes.is_a?(String)
      classes << append_classes 
    elsif append_classes.is_a?(Array)
      classes.concat(append_classes)
    end
    classes.join(" ")
  end
  
end
