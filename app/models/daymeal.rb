class Daymeal < WebDatabase

  self.table_name = 'tbl_essen'
  self.primary_key = "aid"

  belongs_to :event_registration, foreign_key: "aid"
  
  def self.getNumbers(eid)
    @result = {}
    @daymeals = Daymeal.joins(event_registration: :event).where("tbl_events.id = ?", eid).order(:datum)
    @dates = @daymeals.distinct.pluck(:datum)
    @dates.each do |date|
      @result[date] = {:fr => @daymeals.where("datum = ? and mahlzeit = 'fr'", date).sum(:wert),
        :mi => @daymeals.where("datum = ? and mahlzeit = 'mi'", date).sum(:wert),
        :ab => @daymeals.where("datum = ? and mahlzeit = 'ab'", date).sum(:wert) }
    end
    @result
  end
  
end
