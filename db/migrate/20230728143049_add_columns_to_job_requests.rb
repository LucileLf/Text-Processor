class AddColumnsToJobRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :job_requests, :status, :string
    add_column :job_requests, :deadline, :date
  end
end
