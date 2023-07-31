class AddColumnToJobRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :job_requests, :results, :text
  end
end
