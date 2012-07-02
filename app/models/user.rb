class User < ActiveRecord::Base
  include Redis::Objects
  include Parser::Dropbox
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_uniqueness_of :dropbox_id, :allow_nil => true
  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :fotos
  
  hash_key :credentials
  value :dropbox_url
  
  def self.create_by_omniauth(hash, current_user)
    hash = ActiveSupport::HashWithIndifferentAccess.new hash
    user = User.send("find_by_#{hash[:provider]}_id", hash[:uid])
    unless user
      user = User.find_by_email(hash[:info][:email]) || User.new( :email => hash[:info][:email], :name => hash[:info][:name] )
      user.send("#{hash[:provider]}_id=", hash[:uid])
      user.save!
    end
    if hash[:credentials]
      hash[:credentials].each{ |key,value|
        user.credentials[hash[:provider].to_s+"-"+key.to_s] = value 
      }
    end
    user
  end
  
  def password_required?
    return false if dropbox_id
    true
  end
  
  def dropbox_client
    session = DropboxSession.new $Omniauth_Config[:dropbox][:api_key], $Omniauth_Config[:dropbox][:api_secret]
    session.set_access_token credentials["dropbox-token"], credentials["dropbox-secret"]
    DropboxClient.new session, :dropbox
  end

  def init_dropbox_url
    return true if dropbox_url.value
    res = dropbox_client.shares "/Camera Uploads"
    dropbox_url.value = res["url"]
  end
  
end
