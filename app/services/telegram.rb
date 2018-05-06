require 'net/http'
require 'json'

class Telegram
  @@TOKEN = ENV["TELEGRAM_BOT_TOKEN"]

  public
  def self.edit_message_text(chat_id, message_id, text, params={})
    params = {
      'chat_id' => chat_id,
      'message_id' => message_id,
      'text'  => text,
    }.merge(params)

    self.request('editMessageText', params)
  end

  def self.edit_message_caption(chat_id, message_id, text, params={})

    # telegram BUG: both caption and text needed!
    params = {
      'chat_id' => chat_id,
      'message_id' => message_id,
      'caption'  => text,
      'text'  => text,
    }.merge(params)

    self.request('editMessageCaption', params)
  end

  def self.send_message(chat_id, text, params={})
    params = {
      'chat_id' => chat_id,
      'text'  => text,
    }.merge(params)

    self.request('sendMessage', params)
 end

  def self.send_photo(chat_id, caption, photo, params={})
    params = {
      'chat_id' => chat_id,
      'caption'  => caption,
      'photo' => photo,
    }.merge(params)

    self.request_multipart('sendPhoto', params)
  end


  def self.delete_message(chat_id, message_id, params={})
    params = {
      'chat_id' => chat_id,
      'message_id'  => message_id,
    }.merge(params)

    self.request('deleteMessage', params)
 end


  def self.request_multipart(method,params)
    uri = URI("https://api.telegram.org/bot#{@@TOKEN}/#{method}")

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      req = Net::HTTP::Post.new(uri)
      req.set_form(params, 'multipart/form-data')
      http.request(req)
    end

    return JSON.parse(res.body)
  end

  def self.request(method, params)
    uri = URI("https://api.telegram.org/bot#{@@TOKEN}/#{method}")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      req = Net::HTTP::Post.new(uri)
      req['Content-Type'] = 'application/json'
      req.body = params.to_json
      http.request(req)
    end

    return JSON.parse(res.body)
  end
end
