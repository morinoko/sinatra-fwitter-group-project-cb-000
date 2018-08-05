class UsersController < ApplicationController
  configure do
    enable :sessions
    set :session_secret, "fuwafuwa"
  end

  get '/signup' do
    erb :'registration/signup'
  end

  post '/signup' do
    @user = User.new
    @user.username = params[:username]
    @user.email = params[:email]
    @user.password = params[:password]
    @user.save

    session[:id] = @user.id

    redirect to "users/#{@user.slug}"
  end

  get '/users/:slug' do
    @user = User.find_by(id: session[:id])

    erb :'users/show'
  end

  
end
