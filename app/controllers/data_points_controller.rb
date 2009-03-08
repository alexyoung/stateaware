class DataPointsController < ApplicationController
  # Requires a search string
  def index
    # TODO: Search for geographical data
    @data_points = DataPoint.find :all, :conditions => ['']
  end

  # Search for data.  At the moment postcode searches are accepted,
  # but in the future it should allow different data types
  def search
    Api.search_all_apis params[:postcode]
  end
end
