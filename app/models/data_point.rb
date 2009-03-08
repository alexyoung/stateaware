class DataPoint < ActiveRecord::Base
  acts_as_mappable
  belongs_to :api
end
