require 'spec_helper'

describe "accounts/edit.html.haml" do
  before(:each) do
    assign(:account, @account = stub_model(Account,
      :new_record? => false,
      :name => "MyString",
      :subdomain => "MyString"
    ))
  end

  it "renders the edit account form" do
    render

    rendered.should have_selector("form", :action => account_path(@account), :method => "post") do |form|
      form.should have_selector("input#account_name", :name => "account[name]")
      form.should have_selector("input#account_subdomain", :name => "account[subdomain]")
    end
  end
end
