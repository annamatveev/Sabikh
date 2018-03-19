class UsersController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :top_gamers, :least_familiar]

  def create
    user = User.new(username: params[:username], name: params[:name])
    user.photos.build(user: user, uploader: user, url: params[:photo_url])
  end
  def index
    render json: User.all
  end

  def top_gamers
    render json: User.score_board
  end

  def least_familiar
    render json: User.least_familiar
  end
end
