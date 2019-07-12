class StaticPagesController < ApplicationController
  def home
  	@event = current_user.events.build if logged_in?
  end

  def help
  end
end
