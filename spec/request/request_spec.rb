require 'rails_helper'

describe "create a shot", :type => :request do

  before do
    post '/api/v1/urls', params: { :url => { original_url: 'www.anand.com'}}
  end

  it 'returns a created status' do
    expect(response).to have_http_status(:created)
  end

  it 'responds with a message successfully created' do
    message = json["message"]
    expect(message).to eq("successfully created")
  end
  
end