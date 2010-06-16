require 'spec_helper'

describe "applicants/show.html.haml" do
  before(:each) do
    assign(:applicant, @applicant = stub_model(Applicant,
      :first_name => "MyString",
      :last_name => "MyString",
      :email => "MyString",
      :phone => "MyString"
    ))
  end

  it "renders attributes in <p>" do
    render
   rendered.should contain("MyString")
   rendered.should contain("MyString")
   rendered.should contain("MyString")
   rendered.should contain("MyString")
  end
end
