require 'screenshoter'
require 's3_uploader'
class ScreenshotController < ApplicationController
  def shot
    if Rails.env.production?
      if params[:api_key].blank? || params[:api_key] != ENV["SCREENSHOT_API_KEY"]
        render json: {error: "unauthorized"}
        return
      end
    end
    shoter = Screenshoter.new(params[:url])
    uploader = S3Uploader.new
    original_file_path = shoter.shot_as_pc_square
    urls = []
    [320, 640].each do |size|
      resized_file_path = "tmp/#{SecureRandom.hex(16)}.png"
      Magick::Image.read(original_file_path).first.resize_to_fit(size, size).write(resized_file_path)
      urls << uploader.upload(resized_file_path)
    end
    urls << uploader.upload(original_file_path)
    render json: urls, status: :ok
  end
end