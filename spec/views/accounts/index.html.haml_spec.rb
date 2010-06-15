require 'spec_helper'

describe "accounts/index.html.haml" do
  before(:each) do
    assign(:accounts, [
      stub_model(Account,
        :name => "MyString",
        :subdomain => "MyString"
      ),
      stub_model(Account,
        :name => "MyString",
        :subdomain => "MyString"
      )
    ])
  end

  it "renders a list of accounts" do
    render
    rendered.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
  end
end
