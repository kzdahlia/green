class Tagging < ActiveRecord::Base
  validates_presence_of :tag_id
  validates_presence_of :foto_id
  validates_presence_of :user_id
  belongs_to :foto, :counter_cache => :taggings_count
  belongs_to :user
  belongs_to :tag, :counter_cache => :tagging_count
  
  before_validation :sync_user_id
  
  private
  
  def sync_user_id
    self.user_id = tag.user_id
  end
  
end
