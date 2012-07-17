class Foto < ActiveRecord::Base
  include ActsAsEnabled
  mount_uploader :file, ImageUploader
  
  scope :be_queue, where(:fetch_state => nil)
  validates_uniqueness_of :token
  validates_presence_of :token
  validates_presence_of :url
  validates_presence_of :user_id
  serialize :data, Hash
  belongs_to :user
  has_many :taggings
  has_many :tags, :through => :taggings
  
  def has_thumb?
    url_thumb.present?
  end
  
  def data
    ActiveSupport::HashWithIndifferentAccess.new super
  end

  def filename_origin
    url.split("/").last
  end
  
  def fetch_async
    FotoWorker.perform_async(:fetch, id)
    update_column :fetch_state, :queuing
  end
  
  def fetch
    generate_thumb
    fetch_exif
    # fetch_origin_url
    update_column :fetch_state, :finished
  end
  
  def next
    if !@next_foto
      ids = user.fotos.enabled.map(&:id)
      index = ids.index(id) || 0
      index = index - 1 if index > 0
      @next_foto = Foto.find(ids[index])
    end
    @next_foto
  end
  
  def prev
    if !@prev_foto
      ids = user.fotos.enabled.map(&:id).reverse
      index = ids.index(id) || 0
      index = index - 1 if index > 0
      @prev_foto = Foto.find(ids[index])
    end
    @prev_foto
  end
  
  private 
  
  def fetch_exif
    return unless file.file.path
    rmagick = Magick::Image.read(file.file.path).first
    datetime = rmagick.get_exif_by_entry('DateTimeOriginal').first.last
    update_attributes :width => rmagick.get_exif_by_entry('ExifImageWidth').first.last,
                      :height => rmagick.get_exif_by_entry('ExifImageLength').first.last,
                      :datetime => datetime.gsub(datetime[0..9], datetime[0..9].gsub(":", "-"))
  end
  
  def fetch_origin_url
    update_column :url, user.dropbox_client.media("/Camera Uploads/#{filename_origin.gsub("%20", " ")}")['url']
  end
  
  def generate_thumb
    return unless url.present?
    begin
      self.remote_file_url = url
      update_attributes :fetch_state => "thumbnail", :url_thumb => file.thumb.url if self.save
    rescue OpenURI::HTTPError
      self.disable
    end
  end
  
end
