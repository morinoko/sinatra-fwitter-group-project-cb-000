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
end
