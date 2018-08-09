class UsersController < ApplicationController
  get '/signup' do
    if !logged_in?
      erb :'registration/signup'
    else
      @user = current_user
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
    if logged_in?
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
    if logged_in?
      session.clear
      redirect to '/login'
    else
      redirect to '/'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])

    erb :'users/show'
  end
end
