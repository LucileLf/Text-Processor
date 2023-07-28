class CreateJobRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :job_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :text_file, null: false, foreign_key: true

      t.timestamps
    end
  end
end
