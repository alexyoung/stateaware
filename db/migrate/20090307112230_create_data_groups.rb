class CreateDataGroups < ActiveRecord::Migration
  def self.up
    create_table :data_groups do |t|
      t.text :description
      t.string :name
      t.string :icon_file_name
      t.timestamps
    end
  end

  def self.down
    drop_table :data_groups
  end
end
