class User < ActiveRecord::Base
  include Redis::Objects
  include Parser::Dropbox
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :fotos, :order => "datetime DESC"
  
  hash_key :credentials
  
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
  
end
