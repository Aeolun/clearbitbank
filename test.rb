ENV['RACK_ENV'] = 'test'

require './app'
require 'test/unit'
require 'rack/test'

class HelloWorldTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_has_link_button
    get '/'
    assert last_response.ok?
    assert_match 'Link Account', last_response.body
  end
end