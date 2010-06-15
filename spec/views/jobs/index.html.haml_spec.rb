require 'spec_helper'

describe "jobs/index.html.haml" do
  before(:each) do
    assign(:jobs, [
      stub_model(Job,
        :title => "MyString",
        :description => "MyText",
        :status => "MyString"
      ),
      stub_model(Job,
        :title => "MyString",
        :description => "MyText",
        :status => "MyString"
      )
    ])
  end

  it "renders a list of jobs" do
    render
    rendered.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyText".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
  end
end
