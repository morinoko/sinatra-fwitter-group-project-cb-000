class TweetsController < ApplicationController
  get '/tweets' do
    @user = Helpers.current_user(session)
    @tweets = Tweet.all

    erb :'/tweets/index'
  end
end
