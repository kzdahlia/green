Rails.application.config.middleware.use OmniAuth::Builder do
  $Omniauth_Config = ActiveSupport::HashWithIndifferentAccess.new(YAML.load(File.open("#{Rails.root}/config/omniauth.yml"))[Rails.env])
  # perms = 'email,offline_access,user_checkins,friends_checkins,user_location'
  # provider :facebook, $FB_Config[:facebook][:app_id], $FB_Config[:facebook][:api_secret], :scope => perms
  provider :dropbox, $Omniauth_Config[:dropbox][:api_key], $Omniauth_Config[:dropbox][:api_secret]
end