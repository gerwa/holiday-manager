class WebDatabase < ActiveRecord::Base

  self.abstract_class = true
  establish_connection "webdata_database_#{Rails.env}".to_sym
  #replaced for heroku with next line:
  #establish_connection WEB_DATABASE

end
