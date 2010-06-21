require 'spec_helper'

describe "job_flows/index.html.haml" do
  before(:each) do
    assign(:job_flows, [
      stub_model(JobFlow,
        :account_id => 1,
        :job_status_id => 1
      ),
      stub_model(JobFlow,
        :account_id => 1,
        :job_status_id => 1
      )
    ])
  end

  it "renders a list of job_flows" do
    render
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
  end
end
