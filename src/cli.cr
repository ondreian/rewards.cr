require "./rewards"
require "./task"
require "csv"

accounts = CSV.parse(ARGF)
accounts.each do |info|
  account, password = info
  begin
    Task.retry(3) { Rewards.claim!(account, password) }
  rescue error
    puts "account=%s\nerror=%s\ntrace=%s" % [account, error.message, error.backtrace]
  end
end
