class RegistrationsListPdf < PdfReportMethods

  def initialize(event, event_registrations, view)
    super(:margin => [20, 30], :page_size => "A4")
    @event = event
    @regs = event_registrations
    @view = view

    @title = @event.titel
    @sectitle = I18n.l(Time.at(@event.start_datum.to_i).in_time_zone("Rome").to_date, format: "%a, %d.%m.%Y").to_s + ' - ' + I18n.l(Time.at(@event.end_datum.to_i).in_time_zone("Rome").to_date, format: "%a, %d.%m.%Y").to_s

    repeat :all do
      footer(@title, @sectitle)
    end

    bounding_box [bounds.left, bounds.top], :width => bounds.width, :height => bounds.height-25 do

      header
      move_down(10)
      text @title + ', ' + @sectitle
      move_down(10)

      stroke_horizontal_rule
      move_down(10)

      payments_items
    end

    pagenumbers

  end
 
  def payments_items
    table payments_item_rows do

      cells.borders = [:bottom]
      cells.style(:overflow => :shrink_to_fit, :min_font_size => 6, :height => 20, :border_lines => [:dotted], :size => 10)
      style(row(0), :font_style => :italic, :align => :center)
      style(row(-1), :font_style => :bold, :size => 10, :align => :center, :border_width => 1, :borders => [:top])
      
      column(0).width = 15
      column(1).width = 120
      columns(2..3).width = 22
      columns(4..7).width = 18
      column(8).width = 15
      columns(9..14).width = 28
      column(15).width = 15
      column(16).width = 40
      column(17).width = 30

      style(columns(1..2), :size => 8)
      style(column(17), :size => 8)

      columns(2..17).align = :center

      self.header = true
    end
  end

  def payments_item_rows
      [["", "Name", "Alt", "Zi", "Ü", "Fr", "Mi", "Ab", "|", "Ü", "Fr", "Mi", "Ab", "IB", "Ku", "|", "Sum", "bez"]] + 
      @regs.each_with_index.map do |reg, index| 
        [index+1, reg.nachname + ' ' + reg.vorname, nil, 
(reg.getRoomcode[reg.uebernachtung] unless reg.uebernachtung == 0),
 reg.uebernachtung == 0 ? '' : (Time.at(reg.abfahrt.to_i).in_time_zone("Rome").to_date - Time.at(reg.ankunft.to_i).in_time_zone("Rome").to_date).to_i, reg.fr, reg.mi, reg.ab, "|", numformat(reg.ZZi), numformat(reg.Zfr), numformat(reg.Zmi), numformat(reg.Zab), numformat(reg.ZIb), numformat(reg.Zdiv), "|", numformat(reg.ZZi+ reg.Zfr+ reg.Zmi+ reg.Zab+ reg.ZIb+ reg.Zdiv), nil]
      end +
      payments_sums
  end
  
    def payments_sums
      [[{:content => 'SUMMEN', :colspan => 5}, numformat(@regs.sum("v_essen_sum.fr")), numformat(@regs.sum("v_essen_sum.mi")), numformat(@regs.sum("v_essen_sum.ab")), "|", numformat(@regs.sum("tbl_zahlungen.Zi")), numformat(@regs.sum("tbl_zahlungen.fr")), numformat(@regs.sum("tbl_zahlungen.mi")), numformat(@regs.sum("tbl_zahlungen.ab")), numformat(@regs.sum("tbl_zahlungen.Ib")), numformat(@regs.sum("tbl_zahlungen.div")), "|", numformat(@regs.sum("tbl_zahlungen.Zi") + @regs.sum("tbl_zahlungen.fr") + @regs.sum("tbl_zahlungen.mi") + @regs.sum("tbl_zahlungen.ab") + @regs.sum("tbl_zahlungen.Ib") + @regs.sum("tbl_zahlungen.div"))]]
  end

  def numparticipants
    #text "Anzahl Teilnehmer: " + @regs.count.to_s, :size => 16, :style => :bold
  end

  def header
    bounding_box [bounds.left, bounds.top], :width  => bounds.width do
        text "Teilnehmerliste-Zahlungen Begegnungs- und Bildungszentrum Eckstein", :align => :center, :size => 10, :style => :bold
        stroke_horizontal_rule
    end
  end

end
