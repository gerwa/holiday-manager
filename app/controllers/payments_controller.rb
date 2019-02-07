class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payment, only: [:edit, :update, :destroy]

  def edit
  end

  def update
    respond_to do |format|
      if @payment.update(payment_params)
        @registration = EventRegistration.joins(:person, :meal).joins("left outer join tbl_zahlungen on tbl_zahlungen.aid = tbl_anmeldungen.aid").where("tbl_anmeldungen.aid = ?", @payment.aid).select("tbl_anmeldungen.aid, nachname, vorname, ankunft, abfahrt, uebernachtung, bem_essen, bem_anderes, v_essen_sum.fr, v_essen_sum.mi, v_essen_sum.ab, tbl_zahlungen.Zi as ZZi, tbl_zahlungen.Fr as Zfr, tbl_zahlungen.Mi as Zmi, tbl_zahlungen.ab as Zab, tbl_zahlungen.ib as ZIb, tbl_zahlungen.div as Zdiv, tbl_zahlungen.bar as Zbar, tbl_zahlungen.ec as ZEC, tbl_zahlungen.rech as ZRe").first
        format.js {render layout: false}
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end
 
  private
    def set_payment
      @payment = Payment.find(params[:id])
    end

    def payment_params
      params.require(:payment).permit(:Zi, :Fr, :Mi, :Ab, :ib, :div, :bar, :ec, :rech)
    end
end
