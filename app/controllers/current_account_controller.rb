class CurrentAccountController < ApplicationController
  layout 'account'
  
  def index
    render "welcome/index"
  end
end
