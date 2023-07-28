class ChangeColumnsInJobRequests < ActiveRecord::Migration[7.0]
  def change
    add_reference :job_requests, :job, foreign_key: true
    remove_reference :job_requests, :user, foreign_key: true, index: false
  end
end
