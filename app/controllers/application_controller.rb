# frozen_string_literal: true

# Base class for all controllers
class ApplicationController < ActionController::Base
  # skip_before_action :verify_authenticity_token
  protect_from_forgery unless: -> { request.format.json? }
    
  rescue_from ActiveRecord::RecordNotFound, with: :not_found


  # before_action :authenticate
  after_action :set_jwt_token

  private

  def not_found
    render json: { error: 'Not Found' }, status: :not_found
  end

  def authenticate
    rodauth.require_authentication # redirect to login page if not authenticated
  end

  def set_jwt_token
    response.headers['Authorization'] = rodauth.session_jwt if rodauth.use_jwt? && rodauth.valid_jwt?
  end
end
