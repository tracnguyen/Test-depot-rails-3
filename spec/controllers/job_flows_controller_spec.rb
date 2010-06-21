require 'spec_helper'

describe JobFlowsController do

  def mock_job_flow(stubs={})
    @mock_job_flow ||= mock_model(JobFlow, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all job_flows as @job_flows" do
      JobFlow.stub(:all) { [mock_job_flow] }
      get :index
      assigns(:job_flows).should eq([mock_job_flow])
    end
  end

  describe "GET show" do
    it "assigns the requested job_flow as @job_flow" do
      JobFlow.stub(:find).with("37") { mock_job_flow }
      get :show, :id => "37"
      assigns(:job_flow).should be(mock_job_flow)
    end
  end

  describe "GET new" do
    it "assigns a new job_flow as @job_flow" do
      JobFlow.stub(:new) { mock_job_flow }
      get :new
      assigns(:job_flow).should be(mock_job_flow)
    end
  end

  describe "GET edit" do
    it "assigns the requested job_flow as @job_flow" do
      JobFlow.stub(:find).with("37") { mock_job_flow }
      get :edit, :id => "37"
      assigns(:job_flow).should be(mock_job_flow)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created job_flow as @job_flow" do
        JobFlow.stub(:new).with({'these' => 'params'}) { mock_job_flow(:save => true) }
        post :create, :job_flow => {'these' => 'params'}
        assigns(:job_flow).should be(mock_job_flow)
      end

      it "redirects to the created job_flow" do
        JobFlow.stub(:new) { mock_job_flow(:save => true) }
        post :create, :job_flow => {}
        response.should redirect_to(job_flow_url(mock_job_flow))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved job_flow as @job_flow" do
        JobFlow.stub(:new).with({'these' => 'params'}) { mock_job_flow(:save => false) }
        post :create, :job_flow => {'these' => 'params'}
        assigns(:job_flow).should be(mock_job_flow)
      end

      it "re-renders the 'new' template" do
        JobFlow.stub(:new) { mock_job_flow(:save => false) }
        post :create, :job_flow => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested job_flow" do
        JobFlow.should_receive(:find).with("37") { mock_job_flow }
        mock_job_flow.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :job_flow => {'these' => 'params'}
      end

      it "assigns the requested job_flow as @job_flow" do
        JobFlow.stub(:find) { mock_job_flow(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:job_flow).should be(mock_job_flow)
      end

      it "redirects to the job_flow" do
        JobFlow.stub(:find) { mock_job_flow(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(job_flow_url(mock_job_flow))
      end
    end

    describe "with invalid params" do
      it "assigns the job_flow as @job_flow" do
        JobFlow.stub(:find) { mock_job_flow(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:job_flow).should be(mock_job_flow)
      end

      it "re-renders the 'edit' template" do
        JobFlow.stub(:find) { mock_job_flow(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested job_flow" do
      JobFlow.should_receive(:find).with("37") { mock_job_flow }
      mock_job_flow.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the job_flows list" do
      JobFlow.stub(:find) { mock_job_flow(:destroy => true) }
      delete :destroy, :id => "1"
      response.should redirect_to(job_flows_url)
    end
  end

end
