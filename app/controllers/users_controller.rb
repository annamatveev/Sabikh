class UsersController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :create]

  def create
    user = User.create!(username: params[:username], name: params[:name], email: params[:email], password: params[:password])
    Photo.create!(user: user, uploader: user, url: params[:photo_url])
    render json: { body: "Created" }, status: 201
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
