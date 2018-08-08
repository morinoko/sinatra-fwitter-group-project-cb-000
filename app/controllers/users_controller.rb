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

    if @user.save
      session[:user_id] = @user.id
      redirect to '/tweets'
    else
      flash[:notice] = "Please fill in all the fields."
      redirect to '/signup'
    end
  end

  get '/login' do
    if Helpers.logged_in?(session)
      redirect to '/tweets'
    end

    erb :'sessions/login'
  end

  post '/login' do
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "Welcome, #{@user.username}"

      redirect to '/tweets'
    else
      flash[:notice] = "Username or Password was incorrect!"
      redirect to '/login'
    end
  end

  get '/logout' do
    if Helpers.logged_in?(session)
      erb :'sessions/logout'
    else
      redirect to '/login'
    end
  end

  post '/logout' do
    session.clear
    redirect to '/login'
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])

    erb :'users/show'
  end
end
