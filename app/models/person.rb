class Person < WebDatabase

  self.table_name = 'tbl_user'
  self.primary_key = "uid"

  has_many :event_registrations

end
