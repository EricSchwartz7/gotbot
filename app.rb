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
    # check nicknames: if none, don't say anything
    # if nicknames: "My friends call me [list nicknames separated by commas]"

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

      # Find aliases
      # if !resp['aliases'].empty?



      respond_message "My name is #{name}, and I pledge allegiance to #{allegiance}."









    # when 'charbynum'
    #   resp = get_resp("#{got_url}characters/#{repo}")
    #   respond_message "#{resp['name']}"
    # when 'house'
    #   resp = get_resp("#{got_url}houses/#{repo}")
    #   names = resp['swornMembers'].collect do |char|
    #     get_resp("#{char}")['name']
    #   end.join("\n")
    #   respond_message "There are #{resp['swornMembers'].count} characters in #{resp['name']}. Their names are as follows:\n#{names}"

    end

  end

def respond_message message
  content_type :json
  {:text => message}.to_json
end
