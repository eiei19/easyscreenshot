require 'screenshoter'
class ScreenshotController < ApplicationController
  def shot
    shoter = Screenshoter.new("https://500px.com/")
    shoter.shot_as_iphone6
    render json: {}, status: :ok
  end
end