require 'spec_helper'

describe "job_stages/new.html.haml" do
  before(:each) do
    assign(:job_stage, stub_model(JobStage,
      :new_record? => true,
      :account_id => 1,
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders new job_stage form" do
    render

    rendered.should have_selector("form", :action => job_stages_path, :method => "post") do |form|
      form.should have_selector("input#job_stage_account_id", :name => "job_stage[account_id]")
      form.should have_selector("input#job_stage_name", :name => "job_stage[name]")
      form.should have_selector("input#job_stage_description", :name => "job_stage[description]")
    end
  end
end
