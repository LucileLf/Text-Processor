class JobRequestsController < ApplicationController

  def index
    @job_requests = JobRequest.all
  end

  def new
    @job_request = JobRequest.new
  end

  def create
  end
end
