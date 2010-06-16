require 'spec_helper'

describe "applicants/index.html.haml" do
  before(:each) do
    assign(:applicants, [
      stub_model(Applicant,
        :first_name => "MyString",
        :last_name => "MyString",
        :email => "MyString",
        :phone => "MyString"
      ),
      stub_model(Applicant,
        :first_name => "MyString",
        :last_name => "MyString",
        :email => "MyString",
        :phone => "MyString"
      )
    ])
  end

  it "renders a list of applicants" do
    render
    rendered.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
  end
end
