require "spec_helper"

describe PostitsController do
  login_user

  let(:app) { FactoryGirl.create(:application) }
  let(:postit) { app.create_postit(content: "Don't forget I'm a shiny app!") }

  describe "#find_commentable" do
    it "finds commentable based on params if present" do
      get :new, format: "js", commentable_type: "Application", commentable_id: app.id.to_s
      assigns(:commentable).should == app
    end

    it "raises if wrong commentable constant name in params" do
      get :new, commentable_type: "Applicationz", commentable_id: app.id.to_s
      response.status.should == 404
    end

    it "raises if wrong commentable id in params" do
      get :new, commentable_type: "Application", commentable_id: app.id.to_s+"blah"
      response.status.should == 404
    end

    it "raises if wrong params" do
      get :new
      response.status.should == 404
    end
  end

  describe "#new" do
    it "builds a new postit" do
      get :new, format: "js", commentable_type: "Application", commentable_id: app.id.to_s
      assigns(:postit).should be_a Postit
    end
  end

  describe "#create" do
    it "creates a new postit with proposed content" do
      post :create, format: "js", commentable_type: "Application", commentable_id: app.id.to_s,
                    back_url: '/settings', postit: { content: "Blah" }
      response.should redirect_to '/settings'
      app.reload.postit.content.should == "Blah"
    end
  end

  describe "#edit" do
    it "edits an existing postit" do
      get :edit, id: postit.id, format: "js", commentable_type: "Application", commentable_id: app.id.to_s
      assigns(:postit).should == postit
    end
  end

  describe "#update" do
    it "updates the content of an existing postit" do
      put :update, id: postit.id, format: "js", commentable_type: "Application", commentable_id: app.id.to_s,
                   back_url: '/settings', postit: { content: "Foo" }
      response.should redirect_to '/settings'
      app.reload.postit.content.should == "Foo"
    end
  end

  describe "#destroy" do
    it "deletes a postit and redirect back" do
      delete :destroy, id: postit.id, format: "js", commentable_type: "Application", commentable_id: app.id.to_s,
                       back_url: '/settings'
      response.should redirect_to '/settings'
      app.reload.postit.should be_blank
    end
  end
end
