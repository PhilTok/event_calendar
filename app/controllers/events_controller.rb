class EventsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

	def show
		@event = Event.find(params[:id])
  end

  def destroy
  	Event.find(params[:id]).destroy
    flash[:success] = "Event deleted"
    redirect_to root_url
  end

  def new
  	@event = Event.new
  end

  def create
  	@event = Event.new(event_params)
    unless current_user.chat_id.nil? or current_user.chat_id == ''
      message = "You created new event.\n#{@event.name}\n#{@event.content}\n#{@event.datetime.strftime('%d.%m.%y %H:%M')}\n"
      TelegramNotification.send_message(current_user.chat_id, message)
    end
    @event[:user_id] = current_user.id
    if @event.save
      flash[:success] = "Event created!"
      redirect_to @event
    else      
      flash[:success] = "#{@event[:user_id]}"
      redirect_to root_url
    end
  end
  
  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    unless current_user.chat_id.nil? or current_user.chat_id == ''
      message = "You updated your event.\n#{@event.name}\n#{@event.content}\n#{@event.datetime.strftime('%d.%m.%y %H:%M')}\n"
      TelegramNotification.send_message(current_user.chat_id, message)
    end
    if @event.update_attributes(event_params)
      flash[:success] = "Event updated"
      redirect_to @event
    else
      render 'edit'
    end
  end

  def my_events
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  private

    def event_params
      params.require(:event).permit(:name, :content, :datetime, :repeat)
    end

    def correct_user
      @event = current_user.events.find_by(id: params[:id])
      redirect_to root_url if @event.nil?
    end
end
