class PdfReportMethods < Prawn::Document

  # Often-Used Constants
  TABLE_ROW_COLORS = ["FFFFFF","DDDDDD"]
  TABLE_FONT_SIZE = 10
  TABLE_BORDER_STYLE = :grid

  def initialize(default_prawn_options={})
    super(default_prawn_options)
    font_size 10
    stroke_color "b3b3b3"
    line_width(0.5)
    #font "Times-Roman"
    #font Rails.root.join('app', 'assets', 'fonts', 'trado.ttf')
    font_families.update(
      "Lato" => {
        :normal => "app/assets/fonts/Lato-Regular.ttf",
        :bold => "app/assets/fonts/Lato-Bold.ttf",
        :italic => "app/assets/fonts/Lato-Italic.ttf",
        :bold_italic => "app/assets/fonts/Lato-BoldItalic",
      })
    font_families.update("Arial" => {
      :normal => "vendor/assets/fonts/ARIALUNI.TTF",
      :italic => "vendor/assets/fonts/ARIALUNI.TTF",
      :bold => "vendor/assets/fonts/ARIALUNI.TTF",
      :bold_italic => "vendor/assets/fonts/ARIALUNI.TTF"
    })
    font_families.update(
      "DejaVuSans" => {
        :normal => "vendor/fonts/DejaVuSansMono.ttf",
        :bold => "vendor/fonts/DejaVuSansMono-Bold.ttf",
        :italic => "vendor/fonts/DejaVuSansMono-Oblique.ttf",
        :bold_italic => "vendor/fonts/DejaVuSansMono-BoldOblique",
      })

    font "Arial"
    fallback_fonts(["Arial","DejaVuSans" ])

  end

  def reportheader
      draw_text "Begegnungs- und Bildungszentrum Eckstein", :at => [0,745], :size => 11, :style => :bold
      draw_text "Langgasse 9, 6340 Baar/ZG", :at => [245,755], :size => 9
      draw_text "Tel +41-41-766 46 00, Fax -02, info@zentrum-eckstein.ch", :at => [245,743], :size => 9
  end

  def header(title=nil, sectitle=nil, secxpos=200, refnr=nil)
    move_cursor_to 740
    stroke_horizontal_rule
    if title
      draw_text title, :at => [0,695], :size => 14, :style => :bold
    end
    if refnr
      draw_text "(Nr.: " + refnr.to_s + ")", :at => [430,695], :size => 10
    end
    if sectitle
      draw_text sectitle, :at => [secxpos,695], :size => 16, :style => :bold
    end
    move_cursor_to 690
  end

  def pagenumbers
      number_pages "S. <page> von <total>", { :start_count_at => 0, :page_filter => :all, :at => [230, 20], :size => 8 }
  end

  def footer(title=nil, sectitle=nil)
    bounding_box [bounds.left, bounds.bottom + 25], :width  => bounds.width do
      stroke_horizontal_rule
      #font "Helvetica"
      move_down(5)

    if title
      text title, :size => 8
      printpos = 4
    end
    if sectitle
      text sectitle, :size => 8
      printpos = 12
    end
      draw_text "Druckdatum: " + Time.now.strftime('%d.%m.%Y %H:%m'), :at => [380, printpos], :size => 8
    end
  end

  def logoimg
    logo = "#{Rails.root}/app/assets/images/Logo_Eckstein.jpg"
    image logo, height: 55.mm, position: :right
    #image "#{Rails.root}/app/assets/images/Logo_Eckstein.jpg", :at => [200, y_position], :height => 100
  end

  def addressfooter
    bounding_box [bounds.left, bounds.bottom + 14], :width  => bounds.width do
      #font "Helvetica"
      move_down(5)

      draw_text "Trägerschaft", :at => [0, 10], :size => 6
      draw_text "Fokolar-Bewegung", :at => [0, 0], :size => 6

      draw_text "Langgasse 9", :at => [100, 10], :size => 6
      draw_text "CH-6340 Baar/ZG", :at => [100, 0], :size => 6

      draw_text "Tel. +41(0)41- 766 46 00", :at => [200, 10], :size => 6
      draw_text "Fax +41(0)41- 766 46 02", :at => [200, 0], :size => 6

      draw_text "info@zentrum-eckstein.ch", :at => [300, 10], :size => 6
      draw_text "www.zentrum-eckstein.ch", :at => [300, 0], :size => 6

      draw_text "Zuger Kantonalbank, SWIFT: KBZGCH22", :at => [400, 10], :size => 6
      draw_text "IBAN: CH71 0078 7000 1705 1880 6", :at => [400, 0], :size => 6
    end
  end

  def morepages_footer(title)
    bounding_box [bounds.left, bounds.bottom+10], :width  => bounds.width do
      stroke_horizontal_rule
      move_down(8)
      draw_text title, :at => [0, 0], :size => 6
    end
  end

  def morepages_pagenumber
    bounding_box [bounds.left, bounds.bottom+7], :width  => bounds.width do
      number_pages "S. <page> von <total>", { :start_count_at => 0, :page_filter => :all, :at => [430, 0], :size => 6 }
    end
  end

  def numformat(num)
    @view.number_format_nozeros(num)
  end

  def numformat_nozero(num)
    num == 0 ? '' : @view.number_format_nozeros(num)
  end

  def price(num)
    @view.number_format(num)
  end

  def add_page_break_if_overflow(pdf, &block)
    current_page = pdf.page_count
    roll = pdf.transaction do
      yield(pdf)
    
      pdf.rollback if pdf.page_count > current_page
    end
    
    if roll == false
      pdf.start_new_page
      yield(pdf)
    end
  end

  # ... More helpers
end
