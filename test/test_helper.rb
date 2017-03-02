ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  # Add more helper methods to be used by all tests here...
  def assert_select_and_match(selector, match, match_count=1)
    match_counter = 0
    if match_count == 0
      assert_select selector, false
    else
      assert_select selector do |elements|
        elements.each do |element|
          match_counter += 1 if element.content.match(match)
        end
      end

      assert_equal match_counter, match_count
    end
  end
end

class ActionDispatch::IntegrationTest
  def setup
    login_as users(:ifournight)
  end
  
  def login_as(user)
    post login_url, params: { name: user.name, password: 'secret' }
  end

  def logout
    delete logout_url
  end
end