module Parser::Dropbox

  extend ActiveSupport::Concern

  included do
    send :init_dropbox
  end

  module ClassMethods
    
    protected
    
    def init_dropbox
      validates_uniqueness_of :dropbox_id, :allow_nil => true
      value :dropbox_url
    end
  end
  
  module InstanceMethods
    
    def fetch(url)
      RestClient.get(url)
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
    
    def parse_dropbox_photos(url = nil)
      url ||= dropbox_url.value
      content = fetch(url)
      if content.index "should be redirected automatically"
        res = Net::HTTP.get_response(URI.parse(url))
        content = fetch(res["location"])
      end
      content.scan(/<a href="([^"]+)" target="_top".*?><img data\-src="([^"]+)"/m).each do |tmps|
        next if Foto.find_by_url(tmps[1]) || tmps[1].index(".mov")
        foto_url = convert_dropbox_url(tmps[1])
        fotos.create :url => foto_url, :url_thumb => tmps[1], :data => { :dropbox_url => tmps[0] }, :datetime => parse_dropbox_foto_datetime(foto_url)
      end
    end

    private

    def convert_dropbox_url(url)
      url.gsub(/photos\-[0-9]+\.dropbox\.com/, 'photos-1.dropbox.com').gsub(/\/si\/[^\/]+\//, "/si/xl/")
    end

    def parse_dropbox_foto_datetime(url)
      url.scan(/\/([0-9][0-9][0-9][0-9]\-[0-9][0-9]\-[0-9][0-9]%20[0-9][0-9]\.[0-9][0-9]\.[0-9][0-9])/)[0][0].gsub("%20"," ").gsub(".", ":") rescue nil
    end
    
  end
  
end
