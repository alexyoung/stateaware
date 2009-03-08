class Scraper < ActiveRecord::Base
  has_many :scraper_tasks
  has_many :data_points
  has_one :default_task, :class_name => 'ScraperTask'
  belongs_to :data_group

  def run_task(task, value)
    ScraperParser.new(script).send(:search, value)
  end
  
  def self.import
    Dir.glob(RAILS_ROOT + '/lib/scrapers/*.scraper').each do |file_name|
      puts "Importing #{file_name}"

      script = File.open(file_name).read
      scraper_parser = ScraperParser.new(script)
      data_group = DataGroup.find_or_create_by_name scraper_parser._data_group_name
      scraper = if scraper = Scraper.find_by_name_and_namespace(scraper_parser._name, 'System')
        scraper.update_attributes(:name => scraper_parser._name,
        :namespace => 'System',
        :script => script,
        :data_group => data_group,
        :description => scraper_parser._description)
        scraper
      else
        Scraper.create(
          :name => scraper_parser._name,
          :namespace => 'System',
          :script => script,
          :data_group => data_group,
          :description => scraper_parser._description)
      end
      
      scraper_parser.tasks.each do |name, t|
        name = name.to_s

        next if t[:private]
        task = if task = ScraperTask.find_by_name_and_scraper_id(name, scraper.id)
          task.update_attributes(:scraper => scraper, :name => name)
          task
        else
          ScraperTask.create(:scraper => scraper, :name => name)
        end

        if task.name == scraper_parser._default.to_s
          scraper.update_attribute(:default_scraper_task_id, task.id)
        end
      end
    end
  end
end
