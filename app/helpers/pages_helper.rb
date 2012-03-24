module PagesHelper
  def encoded_info_email_address
    mail_to "info@flickstitch.com", "info@flickstitch.com", :encode => "javascript"
  end
end
