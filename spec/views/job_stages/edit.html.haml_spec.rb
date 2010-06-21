require 'spec_helper'

describe "job_stages/edit.html.haml" do
  before(:each) do
    assign(:job_stage, @job_stage = stub_model(JobStage,
      :new_record? => false,
      :account_id => 1,
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit job_stage form" do
    render

    rendered.should have_selector("form", :action => job_stage_path(@job_stage), :method => "post") do |form|
      form.should have_selector("input#job_stage_account_id", :name => "job_stage[account_id]")
      form.should have_selector("input#job_stage_name", :name => "job_stage[name]")
      form.should have_selector("input#job_stage_description", :name => "job_stage[description]")
    end
  end
end
