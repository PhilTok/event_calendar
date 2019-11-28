class Event < ApplicationRecord
  belongs_to :user
  validates :datetime, presence: true
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 25 }
  validates :content, length: { maximum: 140 }
  default_scope -> { order(:datetime) }

  def call_notifications
  	Event.all.each do |e|
  		if (e.datetime - DateTime.now) <= 2.hours
		    message = "You're less than two hours away from your event.\n#{e.name}\n#{e.content}\n#{e.datetime.strftime('%H:%M')}\n"
		    TelegramNotification.send_message(current_user.chat_id, message)
		  end
    end
  end

  def clear
  	Event.all.each do |e|
  		if e.datetime < DateTime.now
  			if e.repeat == "Daily"
  				event = Event.new(e.name, e.content, e.datetime + 1.day, e.repeat)
  				event.save
				elsif e.repeat == "Weekly"
					event = Event.new(e.name, e.content, e.datetime + 1.week, e.repeat)
  				event.save
				elsif e.repeat == "Monthly"
					event = Event.new(e.name, e.content, e.datetime + 1.month, e.repeat)
  				event.save
				elsif e.repeat == "Yearly"
					event = Event.new(e.name, e.content, e.datetime + 1.year, e.repeat)
  				event.save
				end
  			e.destroy
			end
		end
	end
end
