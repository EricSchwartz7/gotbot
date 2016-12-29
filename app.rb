require 'sinatra'
require 'httparty'
require 'json'
require 'pry'

get '/' do
  erb :show
end

def get_resp(url)
  resp = HTTParty.get(url)
  JSON.parse resp.body
end

## Receive post at '/gateway' and send to url
post '/gateway' do
  message = params[:text]

  url = "http://www.anapioficeandfire.com/api/"
  # action, repo = message.split(' ').map {|c| c.strip.downcase }

  case message

    when 'fire'
      respond_message ":fire:" * 100
    when 'winter is coming'
    # 2138 characters
    # output character name
    # check allegiances: if none, say "I pledge allegiance to no house."
    # if allegiance, "I pledge allegiance to [house]."

      number = rand(1..2138)

      # Get character name
      char_url = "#{url}characters/#{number}"
      resp = get_resp(char_url)
      name = resp['name']

      # Find house allegiance
      if resp['allegiances'].empty?
        allegiance = "no house"
      else
        house_url = resp['allegiances'].first
        house_resp = get_resp(house_url)
        allegiance = house_resp['name']
      end

      respond_message "Your name is #{name}, and you pledge allegiance to #{allegiance}."

    end

  end

def respond_message message
  content_type :json
  {:text => message}.to_json
end
