class FotoWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false
  
  def perform(method_name, *args)
    send(method_name, *args)
  end
  
  private 
  
  def fetch(foto_id)
    Foto.find(foto_id).fetch
  end
  
end