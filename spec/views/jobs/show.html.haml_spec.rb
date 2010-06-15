require 'spec_helper'

describe "jobs/show.html.haml" do
  before(:each) do
    assign(:job, @job = stub_model(Job,
      :title => "MyString",
      :description => "MyText",
      :status => "MyString"
    ))
  end

  it "renders attributes in <p>" do
    render
   rendered.should contain("MyString")
   rendered.should contain("MyText")
   rendered.should contain("MyString")
  end
end
