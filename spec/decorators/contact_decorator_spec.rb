require 'spec_helper'

describe ContactDecorator do
  before do
    @contact = Factory(:contact).decorate
  end

  it "return a clean form for mailing lists" do
###    @contact.for_mailing_lists
  end
end
