class Event < ApplicationRecord
  belongs_to :user
  validates :datetime, presence: true
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 25 }
  default_scope -> { order(:datetime) }

  def self.call_notifications
  	Event.all.each do |e|
  		if (e.datetime - (DateTime.now + 3.hours)) <= 1.hours and (e.datetime - (DateTime.now + 3.hours)) >= 1.minute
        unless User.find(e.user_id).chat_id.nil? or User.find(e.user_id).chat_id == ''
  		    message = "You're less than one hour away from your event.\n#{e.name}\n#{e.content}\n#{e.datetime.strftime('%H:%M')}\n"
  		    TelegramNotification.send_message(User.find(e.user_id).chat_id, message)
        end
		  end
    end
  end

  def self.clear
  	Event.all.each do |e|
  		if e.datetime < (DateTime.now + 3.hours)
  			if e.repeat == "Daily"
  				event = Event.new(name: e.name, content: e.content, datetime: e.datetime + 1.day, repeat: e.repeat)
  				event.save
				elsif e.repeat == "Weekly"
					event = Event.new(name: e.name, content: e.content, datetime: e.datetime + 1.week, repeat: e.repeat)
  				event.save
				elsif e.repeat == "Monthly"
					event = Event.new(name: e.name, content: e.content, datetime: e.datetime + 1.month, repeat: e.repeat)
  				event.save
				elsif e.repeat == "Yearly"
					event = Event.new(name: e.name, content: e.content, datetime: e.datetime + 1.year, repeat: e.repeat)
  				event.save
				end
  			e.destroy
			end
		end
	end
end
