class AddSerializedTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :tasks, :string
  end
end
