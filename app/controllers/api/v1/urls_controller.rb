class Api::V1::UrlsController < Api::ApiController
  before_action :find_url, only: [:show]
  before_action :authenticate

  def index
    @url = Url.new
  end

  def show
    redirect_to @url.sanitized_url
  end

  def create
    @url = Url.new(url_params)
    @url.beautify
    if @url.new_url?
      if @url.save
        render json: {message: 'successfully created', short_url: shortened_path(@url.short_url) }, status: :created
      else
        render json: {message: 'error happend'}, status: :failed
      end
    else
      flash[:notice] = "This URL is already in our database"
      render json: {message: 'url alredy exist', short_url: @url.find_duplicate.short_url}, status: :failed
    end
  end

  private

  def find_url
    @url = Url.find_by_short_url(params[:short_url])
  end

  def url_params
    params.require(:url).permit(:original_url)
  end
end
