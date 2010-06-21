require 'spec_helper'

describe "job_states/edit.html.haml" do
  before(:each) do
    assign(:job_state, @job_state = stub_model(JobState,
      :new_record? => false,
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit job_state form" do
    render

    rendered.should have_selector("form", :action => job_state_path(@job_state), :method => "post") do |form|
      form.should have_selector("input#job_state_name", :name => "job_state[name]")
      form.should have_selector("input#job_state_description", :name => "job_state[description]")
    end
  end
end
