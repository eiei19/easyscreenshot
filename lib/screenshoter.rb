require "capybara/poltergeist"

class Screenshoter
  include Capybara::DSL
  Capybara.register_driver :poltergeist_shot do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      js_errors: false,
      phantomjs_options: ["--ssl-protocol=TLSv1"],
      debug: false,
      timeout: 20
    )
  end
  Capybara.current_driver = :poltergeist_shot

  attr_accessor :url
  def initialize(url)
    @url = url
  end

  def shot_as_iphone6
    Capybara.current_session.driver.add_header(
      "User-Agent",
      "Mozilla/5.0 (iPhone; CPU iPhone OS 9_0 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13A344 Safari/601.1"
    )
    shot(375, 667)
  end

  def shot_as_pc
    set_user_agent_chrome
    shot(1024, 768)
  end

  def shot_as_pc_square
    set_user_agent_chrome
    shot(1024, 1024)
  end

  private
    def set_user_agent_chrome
      Capybara.current_session.driver.add_header(
        "User-Agent",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36"
      )
    end

    def shot width, height
      visit(@url)
      page.driver.resize_window width, height
      sleep(5)
      page.save_screenshot("tmp/screenshot.png")
    end

end