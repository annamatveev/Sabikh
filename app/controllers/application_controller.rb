class ApplicationController < ActionController::Base
  respond_to :html, :json
  protect_from_forgery unless: -> { request.format.json? }
  skip_before_filter :verify_authenticity_token
end
