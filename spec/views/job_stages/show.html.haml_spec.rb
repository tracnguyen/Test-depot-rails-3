require 'spec_helper'

describe "job_stages/show.html.haml" do
  before(:each) do
    assign(:job_stage, @job_stage = stub_model(JobStage,
      :account_id => 1,
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders attributes in <p>" do
    render
   rendered.should contain(1)
   rendered.should contain("MyString")
   rendered.should contain("MyString")
  end
end
