require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "fuwafuwa"
    use Rack::Flash, :sweep => true
  end

  get '/' do
    if Helpers.logged_in?(session)
      redirect to '/tweets'
    end
    
    erb :index
  end
end
