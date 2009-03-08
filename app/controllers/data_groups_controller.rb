class DataGroupsController < ApplicationController
  # Return a list of all data groups
  def index
    @data_groups = DataGroup.find :all, :order => 'name'

    respond_to do |wants|
      wants.xml { render :xml => @data_groups }
      wants.json { render :json => @data_groups }
    end
  end
  
  # Return a specific data group
  def show
    @data_group = DataGroup.find params[:id]

    respond_to do |wants|
      wants.xml { render :xml => @data_group }
      wants.json { render :json => @data_group }
    end
  end
end
