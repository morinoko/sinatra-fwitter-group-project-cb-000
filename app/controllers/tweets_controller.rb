class TweetsController < ApplicationController
  get '/tweets' do
    if Helpers.logged_in?(session)
      @user = Helpers.current_user(session)
      @tweets = Tweet.all

      erb :'/tweets/index'
    else
      flash[:notice] = 'You need to be logged in to view tweets!'
      redirect to '/login'
    end
  end

  get '/tweets/new' do
    if Helpers.logged_in?(session)
      erb :'tweets/new'
    else
      flash[:notice] = "You need to be logged in to make a tweet!"
      redirect to '/login'
    end
  end

  post '/tweets' do
    @user = Helpers.current_user(session)
    @tweet = Tweet.new
    @tweet.content = params[:content]

    if @tweet.content.empty?
      flash[:notice] = "You cannot have a blank tweet!"
      redirect to '/tweets/new'
    end

    @tweet.user = @user
    @tweet.save

    redirect to '/tweets'
  end

  get '/tweets/:id' do
    if Helpers.logged_in?(session)
      @tweet = Tweet.find_by(id: params[:id])
      erb :'tweets/show'
    else
      flash[:notice] = "You need to login to see this tweet!"
      redirect to '/login'
    end
  end

  post '/tweets/:id' do
    @tweet = Tweet.find_by(params[:id])
  end

  get '/tweets/:id/edit' do
    if Helpers.logged_in?(session)
      @user = Helpers.current_user(session)
      @tweet = Tweet.find_by(params[:id])

      if @tweet.user == @user
        @tweet = Tweet.find_by(id: params[:id])
        erb :'tweets/edit'
      else
        flash[:notice] = "You can only edit your own tweets."
        redirect to '/tweets'
      end
    else
      flash[:notice] = "You need to login to edit tweets!"
      redirect to '/login'
    end
  end

end
