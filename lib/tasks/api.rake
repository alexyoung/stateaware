require RAILS_ROOT + '/config/environment'

namespace :api do
  desc 'Imports available API classes from models/api into the database'
  task :import do
    Api.import
    Scraper.import
  end
end
