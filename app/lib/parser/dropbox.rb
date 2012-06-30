class Parser::Dropbox
  def fetch(url)
    RestClient.get(url)
  end
  
  def parse_photos(url)
    content = fetch(url)
    if content.index "should be redirected automatically"
      res = Net::HTTP.get_response(URI.parse(url))
      content = fetch(res["location"])
    end
    content.scan(/<img data\-src="([^"]+)"/m)
  end
end