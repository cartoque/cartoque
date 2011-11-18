require 'spec_helper'

describe ServersController do
  # ApplicationController tests except those for authentication (tested in authentication_spec.rb)
  # Those tests are here because they're made using other controllers, making sure ApplicationController
  # inherited properties work as expected.
  describe "ApplicationController" do
    render_views

    describe "catches ActiveRecord::RecordNotFound exceptions" do
      before do
        controller.session[:user_id] = Factory(:user).id
      end

      it "and renders a 404 error message when format is html" do
        get :show, :id => 0
        response.status.should == 404
        response.body.should include("These are not the droids you're looking for")
      end

      it "and returns just a head not found for other formats" do
        get :show, :id => 0, :format => "json"
        response.status.should == 404
        response.body.should be_blank
      end
    end
  end
end
