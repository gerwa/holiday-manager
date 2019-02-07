class VisitorsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @events = Event.futureEckstein
  end


end
