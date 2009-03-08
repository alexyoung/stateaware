class CreateDataPoints < ActiveRecord::Migration
  def self.up

#    data_points.create :link => result.mp_website,
#      :name => result.name,
#      :address => postcode,
#      :api => data_group,
#      :entity_type => 'Person',
#      :additional_links => { 'Wikipedia' => result.wikipedia_url },
#      :data_summary => { 'Debates spoken in over the last year' => result.debate_sectionsspoken_inlastyear },
#      :original_data => result


    create_table :data_points do |t|
      t.string :name
      t.text :address
      t.text :link
      t.integer :api_id
      t.integer :scraper_id
      t.string :entity_type
      t.text :additional_links
      t.text :data_summary
      t.text :original_data
      t.decimal :lng, :precision => 15, :scale => 10
      t.decimal :lat, :precision => 15, :scale => 10
      t.timestamps
    end
  end

  def self.down
    drop_table :data_points
  end
end
