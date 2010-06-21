require 'spec_helper'

describe "job_states/show.html.haml" do
  before(:each) do
    assign(:job_state, @job_state = stub_model(JobState,
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders attributes in <p>" do
    render
   rendered.should contain("MyString")
   rendered.should contain("MyString")
  end
end
