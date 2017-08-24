class BassiVerattiMailer < ActionMailer::Base
  default from: "no-reply@bassi-veratti.stanford.edu"

  def contact_message(opts = {})
    params = opts[:params]
    @request = opts[:request]
    @message = params[:message]
    @email = params[:email]
    @name = params[:name]
    @subject = params[:subject]
    @from = params[:from]
    to = BassiVeratti::Application.config.contact_us_recipients[@subject]
    cc = BassiVeratti::Application.config.contact_us_cc_recipients[@subject]
    mail(:to => to, :cc => cc, :subject => "Contact Message from Bassi Veratti Digital Library - #{@subject}")
  end
end
