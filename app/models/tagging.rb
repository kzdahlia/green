class Tagging < ActiveRecord::Base
  validates_uniqueness_of :name, :scope => [:user_id], :case_sensitive => false
  validates_presence_of :tag_id
  validates_presence_of :foto_id
  validates_presence_of :user_id
  belongs_to :foto
  belongs_to :user
  belongs_to :tag
  
  before_save :sync_user_id
  
  private
  
  def sync_user_id
    self.user_id = tag.user_id
  end
  
end
