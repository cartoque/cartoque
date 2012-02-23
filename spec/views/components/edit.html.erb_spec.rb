require 'spec_helper'

describe "components/edit" do
  before(:each) do
    @component = assign(:component, stub_model(Component,
      :name => "MyString",
      :website => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit component form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => components_path(@component), :method => "post" do
      assert_select "input#component_name", :name => "component[name]"
      assert_select "input#component_website", :name => "component[website]"
      assert_select "input#component_description", :name => "component[description]"
    end
  end
end
