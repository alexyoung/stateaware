# StateawareApi
module StateawareApi
  def self.enable
    ActiveRecord::Base.class_eval { extend ActiveRecordClassMethods }
  end

  def self.classes
    @classes
  end

  def self.add_api(klass, api_description, data_group_name, methods)
    @classes ||= {}
    @classes[klass.name] ||= {}
    @classes[klass.name][:description] = api_description
    @classes[klass.name][:methods] = methods
    @classes[klass.name][:data_group_name] = data_group_name
  end

  def self.[](class_name)
    return if @classes.nil?
    @classes[class_name]
  end

  module ActiveRecordClassMethods
    def stateaware_api(api_description, options)
      StateawareApi.add_api self, api_description, options[:data_group_name], options[:methods]
    end
  end
end
