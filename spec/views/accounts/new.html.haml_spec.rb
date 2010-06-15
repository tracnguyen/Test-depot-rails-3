require 'spec_helper'

describe "accounts/new.html.haml" do
  before(:each) do
    assign(:account, stub_model(Account,
      :new_record? => true,
      :name => "MyString",
      :subdomain => "MyString"
    ))
  end

  it "renders new account form" do
    render

    rendered.should have_selector("form", :action => accounts_path, :method => "post") do |form|
      form.should have_selector("input#account_name", :name => "account[name]")
      form.should have_selector("input#account_subdomain", :name => "account[subdomain]")
    end
  end
end
