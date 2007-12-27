# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'ec7e40ed6473639513496026840f2f63'
  
	def render_404(log_msg=nil)
		logger.warn("WARNING: " + log_msg) if log_msg
		render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
	end
end
