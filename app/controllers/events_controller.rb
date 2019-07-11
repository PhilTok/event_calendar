class EventsController < ApplicationController

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
    if @event.update_attributes(event_params)
      flash[:success] = "Event updated"
      redirect_to @event
    else
      render 'edit'
    end
  end

  private

    def event_params
      params.require(:event).permit(:name, :content, :datetime, :repeat)
    end
end
