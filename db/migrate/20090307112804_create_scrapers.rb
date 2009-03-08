class CreateScrapers < ActiveRecord::Migration
  def self.up
    create_table :scrapers do |t|
      t.integer :data_group_id
      t.column :name, :string
      t.column :namespace, :string
      t.column :script, :text
      t.column :default_scraper_task_id, :integer
      t.column :description, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :scrapers
  end
end
