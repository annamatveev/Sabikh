class GuessesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :authenticate_user!

  def new
    guess = Guess.generate(current_user.id)

    if guess.nil?
      render json: { body: nil}, status: 204
    else
      render json: guess
    end

  end

  def create
    photo = Photo.find(params[:photo_id])

    is_correct = photo.user_id == params[:guessed_user_id]

    Guess.create(user: current_user, photo: photo, correct: is_correct)

    render json: { body: is_correct },
           status: 200
  end
end
