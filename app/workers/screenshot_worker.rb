require 'screenshoter'
class ScreenshotWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 0

  def perform(url)
    shoter = Screenshoter.new(url)
    shoter.shot_as_iphone6
  end
end