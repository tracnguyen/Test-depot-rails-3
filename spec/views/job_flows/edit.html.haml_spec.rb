require 'spec_helper'

describe "job_flows/edit.html.haml" do
  before(:each) do
    assign(:job_flow, @job_flow = stub_model(JobFlow,
      :new_record? => false,
      :account_id => 1,
      :job_status_id => 1
    ))
  end

  it "renders the edit job_flow form" do
    render

    rendered.should have_selector("form", :action => job_flow_path(@job_flow), :method => "post") do |form|
      form.should have_selector("input#job_flow_account_id", :name => "job_flow[account_id]")
      form.should have_selector("input#job_flow_job_status_id", :name => "job_flow[job_status_id]")
    end
  end
end
