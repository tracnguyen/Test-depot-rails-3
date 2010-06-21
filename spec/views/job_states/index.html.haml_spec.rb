require 'spec_helper'

describe "job_states/index.html.haml" do
  before(:each) do
    assign(:job_states, [
      stub_model(JobState,
        :name => "MyString",
        :description => "MyString"
      ),
      stub_model(JobState,
        :name => "MyString",
        :description => "MyString"
      )
    ])
  end

  it "renders a list of job_states" do
    render
    rendered.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
  end
end
