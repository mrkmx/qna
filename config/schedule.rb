every 1.days do
  runner 'DailyDigestJob.perform_now'
end

every 30.minutes do
  rake "ts:index"
end
