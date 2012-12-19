class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller 
   include Blacklight::Controller
  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 

  protect_from_forgery

  rescue_from Exception, :with=>:exception_on_website
  layout "bassi"
  
  helper_method :show_terms_dialog?, :on_home_page, :on_collections_pages, :on_background_page, :on_about_pages, :on_inventory_pages, :on_show_page
  
  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end
  
  def show_terms_dialog?
    if cookies[:seen_terms] || on_background_page || on_home_page || on_about_pages
      return false
    else
      cookies[:seen_terms] = { :value => true, :expires => 10.years.from_now }
      return true
    end
  end

  def request_path
    Rails.application.routes.recognize_path(request.path)
  end
  
  def on_home_page
    request.path == '/' && params[:f].blank?
  end
  
  def on_collections_pages
    request_path[:controller] == 'catalog' && !on_home_page
  end

  def on_show_page
    request_path[:controller] == 'catalog' && request_path[:action] == 'show'
  end
  
  def on_background_page
    request_path[:controller] == 'about' && request_path[:action] == 'background'
  end
  
  def on_about_pages
    request_path[:controller] == 'about' && !on_background_page
  end

  def on_inventory_pages
    request_path[:controller] == 'inventory'
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
      
end
