require 'spec_helper'

describe "Roles" do
  let(:user) { FactoryGirl.create(:user) }
  let!(:role) { Role.create! valid_attributes }

  before do
    login_as user
  end

  # Minimal set of attributes required to create a valid Role
  def valid_attributes
    { name: "Expert" }
  end

  describe "GET /roles" do
    it "list all roles" do
      visit roles_path
      page.status_code.should == 200
      page.should have_content "Expert"
    end
  end

  describe "GET /roles/new & POST /roles" do
    it "creates a new role with valid attributes" do
      visit new_role_path
      page.status_code.should == 200
      fill_in "role_name", with: "Developer"
      click_button "Create"
      current_path.should == roles_path
      page.should have_content "Developer"
    end

    it "doesn't create a new role if invalid attributes" do
      visit roles_path
      page.should have_content "Expert"
      visit new_role_path
      page.status_code.should == 200
      fill_in "role_name", with: "Expert"
      click_button "Create"
      #TODO: restore this once it gets fixed, currently broken
      #(returns '/roles' while user is correctly returned to /roles/new page)
      # current_path.should == new_role_path
      page.should have_content "New role"
      page.should have_content "is already taken"
      Role.count.should == 1
    end
  end

  describe "GET /roles/:id/edit & PUT /roles/:id" do
    it "edits a role with valid attributes" do
      visit edit_role_path(role.id)
      page.status_code.should == 200
      fill_in "role_name", with: "Senior Expert"
      click_button "Apply modifications"
      current_path.should == roles_path
      page.should have_content "Senior Expert"
    end

    it "doesn't update a role if invalid attributes" do
      role2 = Role.create! valid_attributes.merge(name: "Manager")
      visit roles_path
      page.should have_content "Expert"
      visit edit_role_path(role2.id)
      page.status_code.should == 200
      fill_in "role_name", with: "Expert"
      click_button "Apply modifications"
      #TODO: restore this once it gets fixed, currently broken (see above)
      #current_path.should == edit_role_path(role.id)
      page.should have_content "Edit a role"
      page.should have_content "is already taken"
    end
  end

  describe "DELETE /roles/:id" do
    it "destroys the requested role" do
      Role.count.should == 1
      visit roles_path
      click_link "Delete role #{role.to_param}"
      current_path.should == roles_path
      page.should have_content "Role was successfully destroyed"
      Role.count.should == 0
    end
  end
end
