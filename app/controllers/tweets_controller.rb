class TweetsController < ApplicationController

  get '/tweets' do
    if logged_in?
      @user = current_user
      @tweets = Tweet.all

      erb :'/tweets/index'
    else
      flash[:notice] = 'You need to be logged in to view tweets!'
      redirect to '/login'
    end
  end

  get '/tweets/new' do
    if logged_in?
      erb :'tweets/new'
    else
      flash[:notice] = "You need to be logged in to make a tweet!"
      redirect to '/login'
    end
  end

  post '/tweets' do
    @user = current_user
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
    if logged_in?
      @tweet = Tweet.find_by(id: params[:id])
      erb :'tweets/show'
    else
      flash[:notice] = "You need to login to see this tweet!"
      redirect to '/login'
    end
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find_by(id: params[:id])

    if params[:content].empty?
      flash[:notice] = "Your tweet cannot be blank!"
      redirect to "/tweets/#{@tweet.id}/edit"
    end

    @tweet.update(content: params[:content])
    redirect to "/tweets/#{@tweet.id}"
  end

  delete '/tweets/:id' do
    @tweet = Tweet.find_by(id: params[:id])

    if current_user != @tweet.user
      flash[:notice] = "You can only delete your own tweets!"
    else
      @tweet.delete
    end

    redirect to '/tweets'
  end

  get '/tweets/:id/edit' do
    if logged_in?
      @user = current_user
      @tweet = Tweet.find_by(id: params[:id])

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
