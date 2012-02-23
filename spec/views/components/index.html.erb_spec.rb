require 'spec_helper'

describe "components/index" do
  before(:each) do
    assign(:components, [
      stub_model(Component,
        :name => "Name",
        :website => "Website",
        :description => "Description"
      ),
      stub_model(Component,
        :name => "Name",
        :website => "Website",
        :description => "Description"
      )
    ])
  end

  it "renders a list of components" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Website".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
