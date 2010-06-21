require 'spec_helper'

describe JobStagesController do

  def mock_job_stage(stubs={})
    @mock_job_stage ||= mock_model(JobStage, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all job_stages as @job_stages" do
      JobStage.stub(:all) { [mock_job_stage] }
      get :index
      assigns(:job_stages).should eq([mock_job_stage])
    end
  end

  describe "GET show" do
    it "assigns the requested job_stage as @job_stage" do
      JobStage.stub(:find).with("37") { mock_job_stage }
      get :show, :id => "37"
      assigns(:job_stage).should be(mock_job_stage)
    end
  end

  describe "GET new" do
    it "assigns a new job_stage as @job_stage" do
      JobStage.stub(:new) { mock_job_stage }
      get :new
      assigns(:job_stage).should be(mock_job_stage)
    end
  end

  describe "GET edit" do
    it "assigns the requested job_stage as @job_stage" do
      JobStage.stub(:find).with("37") { mock_job_stage }
      get :edit, :id => "37"
      assigns(:job_stage).should be(mock_job_stage)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created job_stage as @job_stage" do
        JobStage.stub(:new).with({'these' => 'params'}) { mock_job_stage(:save => true) }
        post :create, :job_stage => {'these' => 'params'}
        assigns(:job_stage).should be(mock_job_stage)
      end

      it "redirects to the created job_stage" do
        JobStage.stub(:new) { mock_job_stage(:save => true) }
        post :create, :job_stage => {}
        response.should redirect_to(job_stage_url(mock_job_stage))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved job_stage as @job_stage" do
        JobStage.stub(:new).with({'these' => 'params'}) { mock_job_stage(:save => false) }
        post :create, :job_stage => {'these' => 'params'}
        assigns(:job_stage).should be(mock_job_stage)
      end

      it "re-renders the 'new' template" do
        JobStage.stub(:new) { mock_job_stage(:save => false) }
        post :create, :job_stage => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested job_stage" do
        JobStage.should_receive(:find).with("37") { mock_job_stage }
        mock_job_stage.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :job_stage => {'these' => 'params'}
      end

      it "assigns the requested job_stage as @job_stage" do
        JobStage.stub(:find) { mock_job_stage(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:job_stage).should be(mock_job_stage)
      end

      it "redirects to the job_stage" do
        JobStage.stub(:find) { mock_job_stage(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(job_stage_url(mock_job_stage))
      end
    end

    describe "with invalid params" do
      it "assigns the job_stage as @job_stage" do
        JobStage.stub(:find) { mock_job_stage(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:job_stage).should be(mock_job_stage)
      end

      it "re-renders the 'edit' template" do
        JobStage.stub(:find) { mock_job_stage(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested job_stage" do
      JobStage.should_receive(:find).with("37") { mock_job_stage }
      mock_job_stage.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the job_stages list" do
      JobStage.stub(:find) { mock_job_stage(:destroy => true) }
      delete :destroy, :id => "1"
      response.should redirect_to(job_stages_url)
    end
  end

end
