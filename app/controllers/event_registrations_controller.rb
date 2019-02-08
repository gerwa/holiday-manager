class EventRegistrationsController < ApplicationController
  before_action :authenticate_user!
  
  def registrations_list
    @event = Event.find params[:eid]
    @event.calculateRegistrations
    @event_registrations = EventRegistration.joins(:person, :meal).joins("left outer join tbl_zahlungen on tbl_zahlungen.aid = tbl_anmeldungen.aid").where("eid = ?", @event.id).select("tbl_anmeldungen.aid, nachname, vorname, ankunft, abfahrt, uebernachtung, bem_essen, bem_anderes, v_essen_sum.fr, v_essen_sum.mi, v_essen_sum.ab, tbl_zahlungen.Zi as ZZi, tbl_zahlungen.Fr as Zfr, tbl_zahlungen.Mi as Zmi, tbl_zahlungen.ab as Zab, tbl_zahlungen.ib as ZIb, tbl_zahlungen.div as Zdiv, tbl_zahlungen.bar as Zbar, tbl_zahlungen.ec as ZEC, tbl_zahlungen.rech as ZRe")
    
    respond_to do |format|
      format.pdf do
          pdf = RegistrationsListPdf.new(@event, @event_registrations, view_context)
          send_data pdf.render, filename: "Zahlungsliste",
                                type: "application/pdf",
                                disposition: "inline"
      end
      format.html
    end
  end
  
  def overview
    @event = Event.find params[:eid]
    @rooms = EventRegistration.getRoomcount(@event.id)
    @meals = Daymeal.getNumbers(@event.id)
    @comments = EventRegistration.getComments(@event.id)
    
    respond_to do |format|
      format.pdf do
          pdf = OverviewPdf.new(@event, @rooms, @meals, @comments, view_context)
          send_data pdf.render, filename: "Summen",
                                type: "application/pdf",
                                disposition: "inline"
      end
    end
  end
  
  def roominglist
    @event = Event.find params[:eid]
    @event_registrations = EventRegistration.joins(:person).joins("left outer join tbl_zahlungen on tbl_zahlungen.aid = tbl_anmeldungen.aid").where("eid = ? and uebernachtung > 0", @event.id).select("tbl_anmeldungen.aid, nachname, vorname, ankunft, geburtsdatum, geschlecht, strasse_nr, plz, ort, land, email, telefon, abfahrt, uebernachtung, bem_essen, bem_anderes")
    respond_to do |format|
      format.xls
    end
  end

end
