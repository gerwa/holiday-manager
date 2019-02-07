class Price < WebDatabase

  self.table_name = 'tbl_preise'

  enum artikel: { ez: "ez", dz: "dz", dbz: "dbz", mbz: "mbz", fr: "fr", mi: "mi", ab: "ab", ib: "ib", div: "div" }
  
  def self.getPrice(article, eid)
    @result = Price.where("eid = ? and artikel = ?", eid, article).first
    @result = Price.where("artikel = ?", article).first unless @result
    @result ? @result.preis : 0
  end

end
