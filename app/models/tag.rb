class Tag < ActiveRecord::Base
  validates_uniqueness_of :name, :scope => [:user_id], :case_sensitive => false
  validates_presence_of :name
  validates_presence_of :user_id
  has_many :taggings, :dependepnt => :destroy
  belongs_to :user
end
