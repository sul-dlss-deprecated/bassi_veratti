class BassiVerattiMailer < ActionMailer::Base
  default from: "no-reply@bassi-veratti.stanford.edu"

  def contact_message(opts={})
    @message=opts[:message]
    @email=opts[:email]
    @name=opts[:name]
    @subject=opts[:subject]
    to=BassiVeratti::Application.config.contact_us_recipients[@subject]
    cc=BassiVeratti::Application.config.contact_us_cc_recipients[@subject]    
    mail(:to=>to,:cc=>cc, :subject=>"Contact Message from Bassi Veratti Digital Library - #{@subject}") 
  end

  def error_notification(opts={})
    @exception=opts[:exception]
    @mode=Rails.env
    mail(:to=>BassiVeratti::Application.config.exception_recipients, :subject=>"Bassi Veratti Digital Library Exception Notification running in #{@mode} mode")
  end
  
end
