# Patch that makes capybara accept custom headers before visiting a page
# See: http://stackoverflow.com/questions/7062129/whats-the-best-way-to-set-custom-request-headers-when-using-capybara-in-rspec-r
class Capybara::RackTest::Browser
  attr_writer :options
end

class Capybara::Session
  def set_headers(headers)
    if driver.browser.respond_to?(:options=) #because we've monkey patched it above
      options = driver.browser.options
      if options.nil? || options[:headers].nil?
        options ||= {}
        options[:headers] = headers
      else
        options[:headers].merge!(headers)
      end
      #should be copied by reference but doesn't seem,
      #so we have to manually tell the driver.browser
      #its new options
      driver.browser.options = options
    else
      raise Capybara::NotSupportedByDriverError
    end
  end
end
