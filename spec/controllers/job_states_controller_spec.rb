require 'spec_helper'

describe JobStatesController do

  def mock_job_state(stubs={})
    @mock_job_state ||= mock_model(JobState, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all job_states as @job_states" do
      JobState.stub(:all) { [mock_job_state] }
      get :index
      assigns(:job_states).should eq([mock_job_state])
    end
  end

  describe "GET show" do
    it "assigns the requested job_state as @job_state" do
      JobState.stub(:find).with("37") { mock_job_state }
      get :show, :id => "37"
      assigns(:job_state).should be(mock_job_state)
    end
  end

  describe "GET new" do
    it "assigns a new job_state as @job_state" do
      JobState.stub(:new) { mock_job_state }
      get :new
      assigns(:job_state).should be(mock_job_state)
    end
  end

  describe "GET edit" do
    it "assigns the requested job_state as @job_state" do
      JobState.stub(:find).with("37") { mock_job_state }
      get :edit, :id => "37"
      assigns(:job_state).should be(mock_job_state)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created job_state as @job_state" do
        JobState.stub(:new).with({'these' => 'params'}) { mock_job_state(:save => true) }
        post :create, :job_state => {'these' => 'params'}
        assigns(:job_state).should be(mock_job_state)
      end

      it "redirects to the created job_state" do
        JobState.stub(:new) { mock_job_state(:save => true) }
        post :create, :job_state => {}
        response.should redirect_to(job_state_url(mock_job_state))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved job_state as @job_state" do
        JobState.stub(:new).with({'these' => 'params'}) { mock_job_state(:save => false) }
        post :create, :job_state => {'these' => 'params'}
        assigns(:job_state).should be(mock_job_state)
      end

      it "re-renders the 'new' template" do
        JobState.stub(:new) { mock_job_state(:save => false) }
        post :create, :job_state => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested job_state" do
        JobState.should_receive(:find).with("37") { mock_job_state }
        mock_job_state.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :job_state => {'these' => 'params'}
      end

      it "assigns the requested job_state as @job_state" do
        JobState.stub(:find) { mock_job_state(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:job_state).should be(mock_job_state)
      end

      it "redirects to the job_state" do
        JobState.stub(:find) { mock_job_state(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(job_state_url(mock_job_state))
      end
    end

    describe "with invalid params" do
      it "assigns the job_state as @job_state" do
        JobState.stub(:find) { mock_job_state(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:job_state).should be(mock_job_state)
      end

      it "re-renders the 'edit' template" do
        JobState.stub(:find) { mock_job_state(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested job_state" do
      JobState.should_receive(:find).with("37") { mock_job_state }
      mock_job_state.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the job_states list" do
      JobState.stub(:find) { mock_job_state(:destroy => true) }
      delete :destroy, :id => "1"
      response.should redirect_to(job_states_url)
    end
  end

end
