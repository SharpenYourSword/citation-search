require "pp"
require "rubygems"
require "bundler/setup"
require "indextank"
require "sinatra"

require 'sinatra/base'

require_relative("../config.rb")

class App < Sinatra::Base

  get "/" do
    if params[:q]


      config = Configuration.keys
      api = IndexTank::Client.new config["indexden_url"]
      index = api.indexes "citations"
      query = params[:q]
      results = index.search(query, fetch: "*")
      p "query"
      p query
      p "--"
      erb :results, locals: {results: results, query: query}
    else
      erb :index
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end