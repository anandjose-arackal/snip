class Api::ApiController < ApplicationController
  private

  def authenticate
    api_key = request.headers['api_key']

    unless api_key != '1234567'
      head status: :unauthorized
      return false
    end
  end

end
