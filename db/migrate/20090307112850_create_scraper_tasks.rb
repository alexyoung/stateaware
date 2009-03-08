class CreateScraperTasks < ActiveRecord::Migration
  def self.up
    create_table :scraper_tasks do |t|
      t.column :name, :string
      t.column :scraper_id, :integer
      t.column :description, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :scraper_tasks
  end
end
