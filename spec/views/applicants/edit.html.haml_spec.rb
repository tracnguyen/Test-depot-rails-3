require 'spec_helper'

describe "applicants/edit.html.haml" do
  before(:each) do
    assign(:applicant, @applicant = stub_model(Applicant,
      :new_record? => false,
      :first_name => "MyString",
      :last_name => "MyString",
      :email => "MyString",
      :phone => "MyString"
    ))
  end

  it "renders the edit applicant form" do
    render

    rendered.should have_selector("form", :action => applicant_path(@applicant), :method => "post") do |form|
      form.should have_selector("input#applicant_first_name", :name => "applicant[first_name]")
      form.should have_selector("input#applicant_last_name", :name => "applicant[last_name]")
      form.should have_selector("input#applicant_email", :name => "applicant[email]")
      form.should have_selector("input#applicant_phone", :name => "applicant[phone]")
    end
  end
end
