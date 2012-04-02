require 'spec_helper'

describe ApplicationsController do
  login_user

  before do
    @application = FactoryGirl.create(:application)
  end

  it "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:applications)
  end

  it "should get new" do
    get :new
    assert_response :success
  end

  it "should create application" do
    lambda{ post :create, application: {"name" => "app-01"} }.should change(Application, :count)
    assert_redirected_to application_path(assigns(:application))
  end

  it "should show application" do
    get :show, id: @application.to_param
    assert_response :success
  end

  it "should access the rest/xml API" do
    app_inst = ApplicationInstance.new(name: "prod", authentication_method: "none", application_id: @application.id.to_s)
    app_inst.servers = [ FactoryGirl.create(:server), FactoryGirl.create(:virtual) ]
    app_inst.save
    get :show, id: @application.to_param, format: :xml
    response.body.should have_selector :css, "application>_id", @application.id.to_s
    assert_equal 1, @application.application_instances.count
    response.body.should have_selector :css, "application>application-instances>application-instance", 1
    assert_equal 2, @application.application_instances.first.servers.count
    response.body.should have_selector :css, "application>application-instances>application-instance>servers>server", 2
  end

  #TODO: restore find by slug
  pending "should access an application through its identifier" do
    get :show, id: @application.ci_identifier, format: :xml
    assert_select "application>id", "#{@application.id}"
  end

  it "should get edit" do
    get :edit, id: @application.to_param
    assert_response :success
  end

  it "should update application" do
    put :update, id: @application.to_param, application: {"name" => "app-02"}
    assert_redirected_to application_path(assigns(:application))
  end

  it "should destroy application" do
    lambda{ delete :destroy, id: @application.to_param }.should change(Application, :count).by(-1)
    assert_redirected_to applications_path
  end

  pending "allows creation with contacts" do
    contacts_count = Contact.count
    contact_relations_count = ContactRelation.count

    Application.find_by_name("webapp-01").should be_blank
    c = FactoryGirl.create(:contact)

    post :create, application: { name: "webapp-01", contact_ids: [c.id] }
    app = Application.find_by_name("webapp-01")
    app.contact_ids.should == [c.id]

    ContactRelation.count.should eq contact_relations_count+1
    app.destroy
    ContactRelation.count.should eq contact_relations_count
  end

  pending "allows update with contacts" do
    app = Application.create!(name: "webapp-01")
    c = FactoryGirl.create(:contact)

    put :update, id: app.id, application: { name: "webapp-01", contact_ids: [] }
    app.reload.contact_ids.should == []

    put :update, id: app.id, application: { name: "webapp-01", contact_ids: [c.id] }
    app.reload.contact_ids.should == [c.id]
  end
end
