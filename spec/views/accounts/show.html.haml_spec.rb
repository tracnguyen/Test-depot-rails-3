require 'spec_helper'

describe "accounts/show.html.haml" do
  before(:each) do
    assign(:account, @account = stub_model(Account,
      :name => "MyString",
      :subdomain => "MyString"
    ))
  end

  it "renders attributes in <p>" do
    render
   rendered.should contain("MyString")
   rendered.should contain("MyString")
  end
end
