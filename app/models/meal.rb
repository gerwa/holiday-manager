class Meal < WebDatabase

  self.table_name = 'v_essen_sum'
  self.primary_key = "aid"

  belongs_to :event_registration, foreign_key: "aid"
  
end
