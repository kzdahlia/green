# encoding: utf-8
class SessionsController < ApplicationController
  def create
    if current_user = User.create_by_omniauth(request.env['omniauth.auth'], current_user)
       flash[:notice] = "從 #{params[:provider]} 登入成功!"
       sign_in_and_redirect :user, current_user
    else
      raise do
        logger.info "request.env['omniauth.auth']: #{request.env['omniauth.auth'].inspect}"
      end
    end  
  end

  def failure
    flash[:error] = params[:message]
    redirect_to new_user_session_path
  end
end
