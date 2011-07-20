require 'test_helper'

class ApplicationUrlTest < ActiveSupport::TestCase
  test "can create a standard url" do
    assert ApplicationUrl.new(:url => "http://www.example.com/").valid?
  end

  test "can't create an empty url" do
    assert ! ApplicationUrl.new(:url => "").valid?
  end

  test "scopes public/private" do
    app = ApplicationUrl.create(:url => "http://www.example.com/")
    assert ApplicationUrl.public.all.include?(app)
    assert ! ApplicationUrl.private.include?(app)
    app.public = false
    app.save
    app.reload
    assert ! ApplicationUrl.public.include?(app)
    assert ApplicationUrl.private.include?(app)
  end
end
