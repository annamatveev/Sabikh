class PhotosController < ApplicationController
  def index
    render json: Photo.all
  end

  def show
    photos = Photo.for_user(params[:id])
    render json: photos
  end

  def create
    photo = Photo.create(user: User.find(params[:user_id]),
                 uploader: User.find(params[:user_id]),
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
