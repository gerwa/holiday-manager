class OverviewPdf < PdfReportMethods

  def initialize(event, rooms, meals, comments, view)
    super(:margin => [20, 30], :page_size => "A4")
    @event = event
    @rooms = rooms
    @meals = meals
    @comments = comments
    @view = view

    @title = @event.titel
    @sectitle = I18n.l(Time.at(@event.start_datum.to_i).in_time_zone("Rome").to_date, format: "%a, %d.%m.%Y").to_s + ' - ' + I18n.l(Time.at(@event.end_datum.to_i).in_time_zone("Rome").to_date, format: "%a, %d.%m.%Y").to_s

    repeat :all do
      footer(@title, @sectitle)
    end

    bounding_box [bounds.left, bounds.top], :width => bounds.width, :height => bounds.height-25 do

      header
      move_down(20)
      text @title + ', ' + @sectitle, :size => 12, :style => :bold
      move_down(20)

      stroke_horizontal_rule
      move_down(20)
      text 'Total Anzahl Anmeldungen:   ' + @event.event_registrations.count.to_s, :size => 12, :style => :bold
      
      move_down(20)
      text 'ZIMMER-RESERVIERUNGEN', :size => 12, :style => :bold
      rooms_items
      
      move_down(50)
      text 'VERPFLEGUNG', :size => 12, :style => :bold
      meals_items
      move_down(10)
      text "Frühstück enthält sowohl Übernachtungs- als auch Tagesgäste, für Abrechnung mit Teilnehmerliste vergleichen!", :size => 10, :style => :italic
      
      move_down(50)
      text 'KOMMENTARE', :size => 12, :style => :bold
      comments_items
    end

    pagenumbers

  end
 
  def rooms_items
    table rooms_item_rows do

      cells.borders = [:bottom]
      cells.style(:overflow => :shrink_to_fit, :min_font_size => 6, :height => 20, :border_lines => [:dotted], :size => 10)
      style(row(0), :font_style => :italic, :align => :center)
      
      columns(0..2).width = 100
      columns(1..2).align = :center

      self.header = true
    end
  end

  def rooms_item_rows
      [["Zimmertyp", "Anzahl Personen", "Anzahl Zimmer"]] + 
      @rooms.map do |key,value| 
        [key, value[0], value[0] / value[1]]
      end
  end
  
  def meals_items
    table meals_item_rows do

      cells.borders = [:bottom]
      cells.style(:overflow => :shrink_to_fit, :min_font_size => 6, :height => 20, :border_lines => [:dotted], :size => 10)
      style(row(0), :font_style => :italic, :align => :center)
      
      columns(0..3).width = 80
      columns(1..3).align = :center

      self.header = true
    end
  end
  
  def meals_item_rows
      [["Datum", "Frühstück", "Mittag", "Abend"]] + 
      @meals.map do |key,value| 
        [Time.at(key.to_i).in_time_zone("Rome").to_date.strftime('%d.%m.%Y'), value[:fr], value[:mi], value[:ab]]
      end
  end
  
  def comments_items
    table comments_item_rows do

      cells.borders = [:bottom]
      cells.style(:overflow => :shrink_to_fit, :min_font_size => 6, :height => 20, :border_lines => [:dotted], :size => 10)
      style(row(0), :font_style => :italic, :align => :center)
      
      columns(0..2).width = 80
      columns(3..4).width = 120  
      columns(1..2).align = :center

      self.header = true
    end
  end
  
  def comments_item_rows
      [["Name", "Ankunft", "Abfahrt", "Bem. Essen", "Bem. Anderes"]] + 
      @comments.map do |comment| 
        [comment.nachname + ' ' + comment.vorname, 
        Time.at(comment.ankunft.to_i).in_time_zone("Rome").to_date.strftime('%d.%m.%Y'), 
        Time.at(comment.abfahrt.to_i).in_time_zone("Rome").to_date.strftime('%d.%m.%Y'),
        comment.bem_essen, comment.bem_anderes]
      end
  end

  def header
    bounding_box [bounds.left, bounds.top], :width  => bounds.width do
        text "Begegnungs- und Bildungszentrum Eckstein", :align => :center, :size => 10, :style => :bold
        stroke_horizontal_rule
    end
  end

end
