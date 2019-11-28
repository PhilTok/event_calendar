class TelegramNotification < ApplicationRecord
	require 'telegram/bot'

	proxy_url = "http://AjnNav:vdBgCj@45.94.230.104:8000"
	if proxy_url
		Faraday.new("https://api.telegram.org", :proxy => proxy_url)
	end

	def self.send_message chat_id = 0, message = 'New Event'

		token = '807639358:AAHITQiTHrhlewYgZbfPiVs47t-g9VWQsv8'
		begin
			Telegram::Bot::Client.run(token) do |bot|
				bot.api.send_message(chat_id: chat_id, text: message, parse_mode: "html")
			end
		end

		return true

	end
end
