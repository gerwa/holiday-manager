class EventRegistration < WebDatabase

  self.table_name = 'tbl_anmeldungen'
  self.primary_key = "aid"

  has_one :meal, foreign_key: "aid"
  has_many :daymeals, foreign_key: "aid"
  has_one :payment, foreign_key: "aid"
  belongs_to :person, foreign_key: "uid", inverse_of: "event_registrations"
  belongs_to :event, foreign_key: "eid"
  
  def getRoomcode
    mapping = {1 => 'EZ', 2 => 'DZ', 3 => 'DBZ', 4 => 'MBZ', 5 => 'MBZ'}
  end
  
  def self.getRoomcount(eid)
    @event_registrations = EventRegistration.where("eid = ?", eid)
    return { 'EZ' => [@event_registrations.where("uebernachtung = 1").count, 1],
      'DZ' => [@event_registrations.where("uebernachtung = 2").count, 2],
      'DBZ' => [@event_registrations.where("uebernachtung = 3").count, 3],
      'MBZ' => [@event_registrations.where("uebernachtung > 3").count, 4] }
  end
  
  def self.getComments(eid)
    @event_registrations = EventRegistration.joins(:person).where("eid = ? and (bem_essen <> '' or bem_anderes <> '')", eid).select("nachname, vorname, ankunft, abfahrt, bem_essen, bem_anderes")
  end

end
