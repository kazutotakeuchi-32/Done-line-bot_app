class LinebotController < ApplicationController
  require 'line/bot'
  protected_from_forgery :except =>[:callback]

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body,signature)
      return head :bad_request
    end
    events = client.parse_events_from(body)
    events.each do |event|
      case event
        when Line::Bot::Event::Message
          case event.type
            when Line::Bot::Event::Message::Text
              message = {
                type: 'text',
                text: event.message['text']
              }
              res=client.reply_message(event['replyToken'],message)
              p res
            end
        end
    end
    head :ok
  end

  private
    def client
      @client ||= Line::Bot::Client.new do |config|
        config.channel_secret = ENV['LINE_BOT_CHANNEL_SECRET']
        config.channel_secret = ENV['LINE_BOT_CHANNEL_TOKEN']
      end
    end

end
