module ApplicationHelper

  def number_to_currency_chf(number)
    number_to_currency(number, :unit => "CHF ", :delimiter => ",", :separator => ".")
  end
 
  def number_format(number)
    number_with_precision(number, :precision => 2, :delimiter => ",", :separator => ".")
  end

  def number_format_no_delimiter(number)
    number_with_precision(number, :precision => 2, :separator => ".")
  end

  def number_format_nozeros(number)
    number_with_precision(number, precision: 2, delimiter: ",", separator: ".", strip_insignificant_zeros: true)
  end

end
