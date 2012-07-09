class Foto < ActiveRecord::Base
  include ActsAsEnabled
  
  validates_uniqueness_of :url
  validates_presence_of :url
  validates_presence_of :user_id
  serialize :data, Hash
  belongs_to :user
  
  def data
    ActiveSupport::HashWithIndifferentAccess.new super
  end

  def filename
    url.split("/").last
  end
end
