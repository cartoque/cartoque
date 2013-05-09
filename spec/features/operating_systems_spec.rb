require 'spec_helper'

describe "OperatingSystems" do
  let(:user) { FactoryGirl.create(:user) }

  before do
    login_as user
    @lnx = OperatingSystem.create!(name: "Linux")
    @sys = OperatingSystem.create!(name: "Debian 6.0", codename: "Squeeze", parent: @lnx)
  end

  describe "GET /operating_systems" do
    it "gets all systems" do
      visit operating_systems_path
      page.status_code.should be 200
      page.body.should have_selector "a[href='#{edit_operating_system_path(@sys)}']", text: "Debian 6.0 Squeeze"
    end
  end

  describe "GET /operating_systems/:id/edit" do
    it "edits an operating system" do
      visit edit_operating_system_path(@sys)
      page.should have_selector "h1", text: "Operating system: Debian 6.0 Squeeze"
      within("#edit_operating_system_#{@sys.to_param}") do
        fill_in 'operating_system_name',     with: 'Debian GNU/Linux 6.0'
        fill_in 'operating_system_codename', with: 'Squeezee'
      end
      click_button 'Apply modifications'
      current_path.should == operating_systems_path
      page.body.should have_selector "a[href='#{edit_operating_system_path(@sys)}']", text: "Debian GNU/Linux 6.0 Squeeze"
    end

    it "changes OS parent gracefully" do
      visit edit_operating_system_path(@sys)
      within("#edit_operating_system_#{@sys.to_param}") do
        select '', from: 'operating_system_parent_id'
      end
      click_button 'Apply modifications'
      @sys.reload.parent.should be_blank

      click_link("Debian 6.0 Squeeze")
      within("#edit_operating_system_#{@sys.to_param}") do
        select 'Linux', from: 'operating_system_parent_id'
      end
      click_button 'Apply modifications'
      @sys.reload.parent.should_not be_blank
      @sys.parent.should == @lnx
    end
  end
end
