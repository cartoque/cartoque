require 'spec_helper'

describe ApplicationUrl do
  it "should create a standard url" do
    ApplicationUrl.new(:url => "http://www.example.com/").should be_valid
  end

  it "shouldn't create an empty url" do
    ApplicationUrl.new(:url => "").should_not be_valid
  end

  it "scopes public/private ApplicationUrls correctly" do
    app = ApplicationUrl.create(:url => "http://www.example.com/")
    ApplicationUrl.public.all.should include(app)
    ApplicationUrl.private.should_not include(app)
    app.public = false
    app.save
    app.reload
    ApplicationUrl.public.should_not include(app)
    ApplicationUrl.private.should include(app)
  end
end
