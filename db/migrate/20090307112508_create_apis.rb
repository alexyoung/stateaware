class CreateApis < ActiveRecord::Migration
  def self.up
    create_table :apis do |t|
      t.integer :data_group_id
      t.string :description
      t.string :type
      t.text :method_specs
      t.timestamps
    end
  end

  def self.down
    drop_table :apis
  end
end
