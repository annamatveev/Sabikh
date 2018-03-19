class PhotosController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :authenticate_user!

  def index
    render json: Photo.all
  end

  def show
    photos = Photo.for_user(current_user.id)
    puts
    render json: photos
  end

  def create
    photo = Photo.create(user: User.find(current_user.id),
                 uploader: User.find(current_user.id),
                 url: params[:url])
    render json: { status: 'Created', id: photo.id },
           status: 201
  end

  def destroy
    Photo.find(params[:id]).destroy
    render json: { status: 'Deleted' },
           status: 200
  end
end
