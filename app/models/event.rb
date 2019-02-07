class Event < WebDatabase

  self.table_name = 'tbl_events'

  has_many :event_registrations, foreign_key: "eid"
  
  def self.futureEckstein
    @events = Event.where("veranstaltungsort = 'Zentrum Eckstein Baar' and start_datum >= ?", Date.today.to_time.to_i).order("start_datum")
  end
  
  def calculateRegistrations
    self.event_registrations.each do |reg|
      @pay = Payment.where("aid = ?", reg.aid).first
      if !@pay
      
        # meals
        @meal = Meal.find reg.aid
        @pay = Payment.new
        @pay.aid = reg.aid
        @pay.Mi = @meal.mi*Price.getPrice('mi', reg.eid)
        @pay.Ab = @meal.ab*Price.getPrice('ab', reg.eid)
        # zimmer
        if reg.uebernachtung != 0
          zimapping = {1 => 'ez', 2 => 'dz', 3 => 'dbz', 4 => 'mbz'}
          roomtype = (zimapping[reg.uebernachtung] || 'mbz')
          numnights = Time.at(reg.abfahrt.to_i).in_time_zone("Rome").to_date - Time.at(reg.ankunft.to_i).in_time_zone("Rome").to_date
          @pay.Zi = numnights*Price.getPrice(roomtype, reg.eid)    #Preise inkl. Frühstück
        else
          @pay.Fr = @meal.fr*Price.getPrice('fr', reg.eid)  #nur Tagesgäste
          @pay.ib = Price.getPrice('ib', reg.eid)
        end
        # diverses
        @pay.div = Price.getPrice('div', reg.eid)
        @pay.save
      end
    end
  end
    
end
