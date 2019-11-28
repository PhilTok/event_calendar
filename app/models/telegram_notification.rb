class TelegramNotification < ApplicationRecord
	require 'telegram/bot'

	proxy_url = "http://AjnNav:vdBgCj@45.94.230.104:8000"
	if proxy_url
		Faraday.new("https://api.telegram.org", :proxy => proxy_url)
	end

	def self.send_message message = "test", chat_id = 0

		chat_id = 201882280

		token = "807639358:AAHITQiTHrhlewYgZbfPiVs47t-g9VWQsv8"
		# token = '890049286:AAGGFOwiRYy_WyWRlv2BXE-RAK6AynWUHQ0'

		
		# conn = Faraday.new("https://api.telegram.org", ssl: {verify:false}) do |conn|
		#   code here ...
		# 	conn.adapter :em_http
		# 	conn.proxy "http://AjnNav:vdBgCj@45.94.230.104:8000"
		# end

		begin
			# status = Timeout::timeout(2) {
				# Telegram::Bot::Client.run(token, url: 'proxy') do |bot|
				Telegram::Bot::Client.run(token) do |bot|
					# bot.api.send_message(chat_id: chat_id, text: message, parse_mode: "markdown")
					bot.api.send_message(chat_id: chat_id, text: message, parse_mode: "html")
				end
			# }
		end

		return true

	end

	def self.send_photo photo, caption = "", chat_id = 0

		if chat_id == 0
			chat_id = @application_setup.tg_chat_id
		end

		token = ""
		token = @application_setup.tg_bot_token

		begin
			Telegram::Bot::Client.run(token) do |bot|
				bot.api.send_photo(chat_id: chat_id, photo: Faraday::UploadIO.new(photo, 'image'), caption: caption, parse_mode: "markdown") # 'image/jpeg'
			end
		rescue Exception => e
			MessageStatus.create(name: "SendPhoto", content: e)
			return false
		end

		return true

	end

	def self.send_file file, caption = "", doc_type = "", chat_id = 0

		if chat_id == 0
			chat_id = @application_setup.tg_chat_id
		end

		token = ""
		token = @application_setup.tg_bot_token

		begin
			Telegram::Bot::Client.run(token) do |bot|
				bot.api.send_document(chat_id: chat_id, document: Faraday::UploadIO.new(file, doc_type), caption: caption, parse_mode: "markdown") # 'image/jpeg'
			end
		rescue Exception => e
			MessageStatus.create(name: "SendFile", content: e)
			return false
		end

		return true
	end
end
