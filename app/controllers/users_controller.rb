class UsersController < ApplicationController
  get '/signup' do
    if !Helpers.logged_in?(session)
      erb :'registration/signup'
    else
      @user = Helpers.current_user(session)
      redirect to "/tweets"
    end
  end

  post '/signup' do
    @user = User.new
    @user.username = params[:username]
    @user.email = params[:email]
    @user.password = params[:password]
    @user.save

    if @user.save
      session[:user_id] = @user.id
      redirect to '/tweets'
    else
      redirect to '/signup'
    end
  end

  get '/login' do
    if !Helpers.logged_in?(session)
      erb :'sessions/login'
    else
      redirect to '/tweets'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      
      redirect to '/tweets'
    else
      redirect to '/login'
    end
  end

  post '/logout' do
    session.clear
    redirect to '/'
  end

  get '/users/:slug' do
    @user = User.find_by(id: session[:user_id])

    erb :'users/show'
  end
end
