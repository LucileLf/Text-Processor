class JobRequestsController < ApplicationController

  def index
    @job_requests = JobRequest.all
  end

  def new
    @job_request = JobRequest.new
    @job_request.build_text_file
  end

  def create
    @job_request = JobRequest.new(job_request_params)
    @job_request.job = Job.find(params[:job_request][:job])
    @text_file = TextFile.create!(file: params[:job_request][:text_file], user: current_user, name: params[:job_request][:text_file].original_filename)
    @job_request.text_file = @text_file
    @job_request.status = "initiated"
    if @job_request.save!
      #change date of execution
      #CountWordsJob.set(wait_until: Date.tomorrow.noon).perform_later(@text_content)
      CountWordsJob.perform_now(@text_file)
      redirect_to job_requests_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def job_request_params
    params.require(:job_request).permit(:job_id, :deadline, text_file_attributes: [:file])
  end
end
