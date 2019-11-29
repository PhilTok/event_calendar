desc "Scheduler notification"
task send_notifications: :environment do
  Event.call_notifications
  Event.clear
end