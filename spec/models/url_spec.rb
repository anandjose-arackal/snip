require 'rails_helper'

RSpec.describe Url, type: :model do

  it "is valid with a valid url" do
    url = build(:url)
    expect(url).to be_valid
  end

  it "is invalid without a url" do
    url = build(:url, original_url: nil)
    url.valid?
    expect(url.errors[:original_url]).to include("Please enter the URL you want to shorten")
  end

  it "is invalid with an invalid URL" do
    url = build(:url, original_url: "abc")
    url.valid?
    expect(url.errors[:original_url]).to include("Please enter a valid URL")
  end

  describe "method" do
    before :each do
      @url_google = create(:url, original_url: "google.com")
      @url_google.beautify
      @url_google.save
    end

    it "#generate_short_url" do
      url = build(:url)
      url.generate_short_url
      expect(url.short_url).to match(/\A[a-z\d]{6}\z/i)
    end

    it "#find_duplicate" do
      url = build(:url, original_url: "www.google.com")
      url.sa
      expect(url.find_duplicate).to eq(@url_google)
    end

    context "#new_url?" do
      it "returns false if the URL is already present" do
        url = build(:url, original_url: "www.google.com")
        url.beautify
        expect(url.new_url?).to eq(false)
      end

      it "returns true if the URL is not found in the database" do
        url = build(:url, original_url: "www.sevatas.com")
        url.beautify
        expect(url.new_url?).to eq(true)
      end
    end

    context "#beautify" do

      it "changes 'www.google.com' to 'http://google.com'" do
        url = build(:url, original_url: 'www.google.com')
        url.beautify
        expect(url.beautifyd_url).to eq('http://google.com')
      end
    end

  end

end