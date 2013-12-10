# Used by 'whenever' gem to update crontab

# Load supporting code and models
require 'rdvr'

def generate_cronjob(show)
  # Don't need to schedule one time shows that have already passed
  # Note: Not all shows have the 'weekly' and 'start' values filled in (e.g. crawled feeds)
  return false if not show.weekly or (show.start and not show.weekly and show.start < Time.now)
  
  # Cron timestamp is different between weekly and one-time recordings
  if show.weekly
    # Show is weekly
    cron_timestamp = "#{show.start.min} #{show.start.hour} * * #{show.start.wday}"
  elsif show.start
    # Show is not weekly but still requires a 'start' (some shows do not have 'start', e.g. crawled feeds)
    cron_timestamp = "#{show.start.min} #{show.start.hour} #{show.start.day} #{show.start.month} #{show.start.wday}"
  end

  path = Gem::Specification.find_by_name("rdvr").gem_dir
  command = "cd #{path} && RDVR_RECORDINGS_DIR=\"#{ENV['RDVR_RECORDINGS_DIR']}\" RDVR_RECORDINGS_DIR_URL=\"#{ENV['RDVR_RECORDINGS_DIR_URL']}\" #{which('bundle')} exec bin/rdvr-record #{show.id}"
  [cron_timestamp, command]
end

Show.all.each do |s|
  cron_info = generate_cronjob(s)
  every cron_info[0] do
    command cron_info[1]
  end if cron_info
end

# Run crawlers daily
every 1.day do
  command "cd #{path} && RDVR_RECORDINGS_DIR=\"#{ENV['RDVR_RECORDINGS_DIR']}\" RDVR_RECORDINGS_DIR_URL=\"#{ENV['RDVR_RECORDINGS_DIR_URL']}\" #{which('bundle')} exec bin/rdvr-run-crawlers"
end
