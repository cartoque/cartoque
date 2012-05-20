require 'spec_helper'

describe ApplicationsController do
  login_user

  before do
    @application = FactoryGirl.create(:application)
  end

  it "gets index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:applications)
  end

  it "gets new" do
    get :new
    assert_response :success
  end

  it "creates application" do
    lambda{ post :create, application: {"name" => "app-01"} }.should change(Application, :count)
    assert_redirected_to application_path(assigns(:application))
  end

  it "shows application" do
    get :show, id: @application.to_param
    assert_response :success
  end

  #TODO: refactor it
  #TODO: move it to a request spec
  it "accesss the rest/xml API" do
    app_inst = ApplicationInstance.new(name: "prod", authentication_method: "none", application_id: @application.id.to_s)
    app_inst.servers = [ FactoryGirl.create(:server), FactoryGirl.create(:virtual) ]
    app_inst.save
    @application.reload
    get :show, id: @application.to_param, format: :xml
    response.body.should have_selector :css, "application>_id", @application.id.to_s
    assert_equal 1, @application.application_instances.count
    response.body.should have_selector :css, "application>application-instances>application-instance", 1
    assert_equal 2, @application.application_instances.first.servers.count
    response.body.should have_selector :css, "application>application-instances>application-instance>servers>server", 2
  end

  it "accesss an application through its identifier" do
    get :show, id: @application.slug, format: :xml
    response.body.should include "<_id>#{@application.id}</_id>"
  end

  it "gets edit" do
    get :edit, id: @application.to_param
    assert_response :success
  end

  it "updates application" do
    put :update, id: @application.to_param, application: {"name" => "app-02"}
    assert_redirected_to application_path(assigns(:application))
  end

  it "destroys application" do
    lambda{ delete :destroy, id: @application.to_param }.should change(Application, :count).by(-1)
    assert_redirected_to applications_path
  end

  describe "contact relations" do
    let!(:app)   { Application.create(name: "Skynet") }
    let!(:role)  { Role.create(name: "Developer") }
    let!(:user1) { Contact.create(last_name: "Mitnick", first_name: "Kevin") }
    let!(:user2) { Contact.create(last_name: "Hoffman", first_name: "Milo") }

    it "allows creation with contacts" do
      contacts_count = Contact.count
      relations_count = Relationship.count

      Application.where(name: "webapp-01").first.should be_blank

      post :create, application: { name: "webapp-01", relationships_map: { role.id.to_s => "#{user1.id},#{user2.id}" } }
      webapp = Application.where(name: "webapp-01").first


      webapp.contacts_with_role(role).should =~ [user1, user2]
      Relationship.count.should eq relations_count + 1

      webapp.destroy
      Relationship.count.should eq relations_count
    end

    it "allows update with contacts" do
      put :update, id: app.id, application: { name: "Skynet", relationships_map: { role.id.to_s => "#{user1.id},#{user2.id}" } }

      app.reload.contacts_with_role(role).should =~ [user1, user2]

      put :update, id: app.id, application: { name: "webapp-01", relationships_map: { } }

      app.reload.contacts_with_role(role).should be_blank
    end
  end
end
