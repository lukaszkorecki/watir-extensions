require 'watir-webdriver'
require 'selenium/server'

module Watir
  # example
  #
  # before :each do
  #   @browsers = {
  #     :chrome => Watir::generate_chrome,
  #     :headless => Watir::generate_headless
  #   }
  # end
  #
  def self.generate_headless
    cap = Selenium::WebDriver::Remote::Capabilities.htmlunit(:javascript_enabled => true)
    Watir::Browser.new(:remote, :url => "http://127.0.0.1:4444/wd/hub", :desired_capabilities => cap)
  end

  def self.selenium_server
    Selenium::Server.new(RAILS_ROOT+'/lib/selenium-server-standalone.jar', :background => true)
  end

  [:chrome, :firefox, :ie].each do |browser|
    self.class.send(:define_method, :"generate_#{browser}") do
      Watir::Browser.new browser
    end
  end


  class Browser
    # elements - plural name of the elements you're searching for i.e. :lis, :spans
    # id - id you're searching for
    def getElementById(element, id )
      self.send(element).select { |el| el.id == id}.first
    end


    # elements - plural name of the elements you're searching for i.e. :lis, :spans
    # class_name - css class name
    def getElementsByClassName(elements, class_name)
      self.send(elements).to_a.select { |el| el.attribute_value('class') =~ /#{class_name}/ }
    end

  end

  class Radio
    # returns true if a radio element is selected
    def selected?
      self.attribute_value("selected").nil? ? false : true
    end
  end

end
