require 'spec_helper'

describe "job_stages/index.html.haml" do
  before(:each) do
    assign(:job_stages, [
      stub_model(JobStage,
        :account_id => 1,
        :name => "MyString",
        :description => "MyString"
      ),
      stub_model(JobStage,
        :account_id => 1,
        :name => "MyString",
        :description => "MyString"
      )
    ])
  end

  it "renders a list of job_stages" do
    render
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
  end
end
