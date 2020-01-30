# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
# set :environment, rails_env
# set :output, "#{Rails.root}/log/cron.log"
#
require File.expand_path(File.dirname(__FILE__) + '/environment')
set :output, "#{Rails.root}/log/cron.log"

every 1.hours do
  rake 'status_task:published'
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
