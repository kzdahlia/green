class Tag < ActiveRecord::Base
  validates_uniqueness_of :name, :scope => [:user_id], :case_sensitive => false
  validates_presence_of :name
  validates_presence_of :user_id
  has_many :taggings, :dependent => :destroy
  has_many :fotos, :through => :taggings
  belongs_to :user
end
