class Api < ActiveRecord::Base
  belongs_to :data_group
  has_many :data_points
  serialize :method_specs

  def self.import
    require_api_files

    StateawareApi.classes.each do |class_name, spec|
      method_specs = spec[:methods]
      data_group_name = spec[:data_group_name]
      description = spec[:description]

      # Find or create the DataGroup for this class and method
      data_group = DataGroup.find_or_create_by_name data_group_name
      klass = class_name.constantize
      api = klass.create :description => description, :method_specs => method_specs, :data_group => data_group
    end
  end

  def self.search_all_apis(value, datatype = :postcode)
    results = []
    Api.find(:all).each do |api|
      api.method_specs.each do |method_name, method_spec|
        if method_spec[:arguments].include? datatype
          results.push api.send(method_name, value)
        end
      end
    end

    Scraper.find(:all).each do |scraper|
      data_point = DataPoint.find_by_address_and_scraper_id(value, scraper.id)
      if data_point
        # TODO: update result
      else
        scraper_results = scraper.run_task :search, value
        data_point = scraper.data_points.create scraper_results
      end 

      if data_point
        results.push data_point
      end
    end
    results
  end

  private
    def self.require_api_files
      path = RAILS_ROOT + '/app/models/api/'
      Dir.open(path).each do |file_name|
        if file_name.match /.*\.rb$/
          require File.join(path, file_name)
        end
      end
    end
end
