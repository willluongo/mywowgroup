require 'haml'
require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'rest_client'
require 'open-uri'

class Player
   attr_accessor :name, :realm, :picture, :level, :info
   def initialize(name, realm)
       @name = name
       @realm = realm
       @url = "https://us.battle.net/api/wow/character/" + URI::encode(@realm) + "/" + URI::encode(@name)
       begin
         @info = JSON.parse(RestClient.get @url)
       rescue => e
         @info = "Error retrieving character"
       end
         
       @level = @info["level"]
       @picture = "https://us.battle.net/static-render/us/" + @info["thumbnail"]
   end
end

get '/' do
    @characters = []
    JSON.parse(File.read("group.json"))["characters"].each do |char|
        @characters.push(Player.new(char["name"],char["realm"]))
    end
    @title = "My WoW group"
    haml :index
end