require 'spec_helper'

describe "job_flows/show.html.haml" do
  before(:each) do
    assign(:job_flow, @job_flow = stub_model(JobFlow,
      :account_id => 1,
      :job_status_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
   rendered.should contain(1)
   rendered.should contain(1)
  end
end
