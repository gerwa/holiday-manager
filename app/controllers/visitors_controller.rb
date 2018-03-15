class VisitorsController < ApplicationController

  def testmail
    MyMailer.testmail('gertraud.wachmann@hotmail.ch').deliver
    redirect_to root_path
  end

end
