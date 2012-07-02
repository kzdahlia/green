module Parser::Dropbox
  def fetch(url)
    RestClient.get(url)
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
      fotos.create :url => convert_dropbox_url(tmps[1]), :url_thumb => tmps[1], :data => { :dropbox_url => tmps[0] }
    end
  end
  
  private
  
  def convert_dropbox_url(url)
    url.gsub(/photos\-[0-9]+\.dropbox\.com/, 'photos-1.dropbox.com').gsub(/\/si\/[^\/]+\//, "/si/xl/")
  end
end