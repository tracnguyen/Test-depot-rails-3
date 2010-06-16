require 'spec_helper'

describe "applicants/new.html.haml" do
  before(:each) do
    assign(:applicant, stub_model(Applicant,
      :new_record? => true,
      :first_name => "MyString",
      :last_name => "MyString",
      :email => "MyString",
      :phone => "MyString"
    ))
  end

  it "renders new applicant form" do
    render

    rendered.should have_selector("form", :action => applicants_path, :method => "post") do |form|
      form.should have_selector("input#applicant_first_name", :name => "applicant[first_name]")
      form.should have_selector("input#applicant_last_name", :name => "applicant[last_name]")
      form.should have_selector("input#applicant_email", :name => "applicant[email]")
      form.should have_selector("input#applicant_phone", :name => "applicant[phone]")
    end
  end
end
