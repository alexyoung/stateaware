# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '5f6ba937d9d0fbcdf8e8a74afe14ebf1'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  rescue_from ActiveRecord::RecordNotFound do |exception|
    api_error({ 'Error' => 'Record not found' })
  end

  protected
    def api_error(error, status = 500)
      respond_to do |wants|
        wants.xml { render :xml => error, :status => status }
        wants.json { render :xml => error, :status => status }
      end
    end
end
