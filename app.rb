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

# Receive post at '/gateway'
post '/gateway' do
  message = params[:text]

  url = "http://www.anapioficeandfire.com/api/"

  case message
    when 'dracarys'
      fire = ":fire:" * 25
      fire_dragon = fire + ":dragon_face: \n"
      respond_message(fire_dragon * 3)
    when 'valar morghulis'
      respond_message 'https://s-media-cache-ak0.pinimg.com/736x/6d/88/bc/6d88bcebfd0b4b4e3ed58bf020248285.jpg'
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

# Convert bot output to JSON which can be read by Slack
def respond_message(message)
  content_type :json
  {:text => message}.to_json
end
