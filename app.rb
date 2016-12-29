require 'sinatra'
require 'httparty'
require 'json'
require 'pry'

get '/' do
  erb :show
end

def get_resp(repo_url)
  resp = HTTParty.get(repo_url)
  JSON.parse resp.body
end

## Receive post at '/gateway' and send to repo_url
post '/gateway' do
  message = params[:text]
  # .gsub(params[:trigger_word], '').strip

  got_url = "http://www.anapioficeandfire.com/api/"
  action, repo = message.split(' ').map {|c| c.strip.downcase }
  repo_url = "https://api.github.com/repos/#{repo}"
  resp = get_resp(repo_url)

  num = rand(699)

  eric = "Eric Schwartz"
  joe = "Joe Sasson"
  ian = "Ian Candy"

  def name_value(name)
    first_name, last_name = name.split
    first_array = first_name.split("")
    last_array = last_name.split("")
    value = first_array[2].ord + last_array[-1].ord
    if first_array[0].ord.odd?
      value += 100
    else
      value -= 100
    end
  end

  case action

    when 'fire'
      respond_message ":fire:" * 100

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
