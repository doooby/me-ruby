class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.date :start_at
      t.date :end_at
      t.string :task
      t.string :text
      t.string :labels

      t.timestamps
    end
  end
end
