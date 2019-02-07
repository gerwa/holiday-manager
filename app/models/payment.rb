class Payment < WebDatabase

  self.table_name = 'tbl_zahlungen'
  self.primary_key = "aid"

  belongs_to :event_registration, foreign_key: "aid"

end
