require 'spec_helper'

describe "job_states/new.html.haml" do
  before(:each) do
    assign(:job_state, stub_model(JobState,
      :new_record? => true,
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders new job_state form" do
    render

    rendered.should have_selector("form", :action => job_states_path, :method => "post") do |form|
      form.should have_selector("input#job_state_name", :name => "job_state[name]")
      form.should have_selector("input#job_state_description", :name => "job_state[description]")
    end
  end
end
