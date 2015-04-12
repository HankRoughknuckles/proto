require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.every '10s' do
  Rails.logger.info "hello, it's #{Time.now}"
end
