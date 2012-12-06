class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller 
   include Blacklight::Controller
  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 

  rescue_from Exception, :with=>:exception_on_website
  layout "bassi"

  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
#    I18n.locale = (BassiVeratti::Application.config.allowed_locales.include?(params[:locale]) ? params[:locale] : I18n.default_locale)
  end
  
  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
#    { :locale => ((I18n.locale == I18n.default_locale) ? nil : I18n.locale) }
    { :locale => I18n.locale }
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
