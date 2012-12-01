class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller 
   include Blacklight::Controller
  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 

  rescue_from Exception, :with=>:exception_on_website
  helper_method :application_name
  layout "bassi"
  

  def application_name
    "Bassi Veratti Digital Library"
  end
    
  def exception_on_website(exception)
    @exception=exception

    BassiVerattiMailer.error_notification(:exception=>@exception).deliver unless BassiVeratti::Application.config.exception_recipients.blank? 

    if BassiVeratti::Application.config.exception_error_page
        logger.error(@exception.message)
        logger.error(@exception.backtrace.join("\n"))
        render "500", :status => 500
      else
        raise(@exception)
     end
  end
      
  protect_from_forgery
end
