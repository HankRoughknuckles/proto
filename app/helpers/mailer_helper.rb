module MailerHelper
  DEVELOPER_EMAIL = [ "thomas.imorris" ].join(", ")
  ADMIN_EMAILS =    [ DEVELOPER_EMAIL, 
                      "ina.kiss1@gmail.com", 
                      "vlad.balan@mylift.ro" 
                    ].join(", ")
  COMPANY_EMAIL =   "gogoprototastic@gmail.com"


  # Returns the passed default_value if rails is running in production,
  # otherwise, it returns the developer's email address
  def set_recipients(default_values)
    Rails.env.production? ? default_values : DEVELOPER_EMAIL
  end


  # Returns the passed default_value if rails is running in production,
  # otherwise, it returns the default value with TEST- on the front
  def set_subject(default_subject)
    Rails.env.production? ? default_subject : "TEST- #{default_subject}"
  end
end
