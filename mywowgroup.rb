require 'haml'
require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'rest_client'

class Player
   attr_accessor :name, :realm, :picture, :url
   def initialize(name, realm)
       @name = name
       @realm = realm
       @url = "https://us.battle.net/api/wow/character/" + @realm + "/" + @name
       @info = RestClient.get @url
       @picture = "https://us.battle.net/static-render/us/" + JSON.parse(@info)["thumbnail"]
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