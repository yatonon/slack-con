require 'octokit'
require 'byebug'
require 'tapp'
require 'date'
require 'dotenv'

class CommitReceiver
  attr_accessor :message
  def initialize
    @message = ''
    Dotenv.load
    client = Octokit::Client.new login: ENV['LOGIN'], password:ENV['PASSWORD']
    commitlist = client.commits ENV['REPOSITORI']
    commitlist
      .select { |commit| commit[:commit][:author][:date].to_date == Date.today-1 }
      .each.with_index(1) do |commit, index|
        @message << index.to_s + '.' + commit[:commit][:message] \
        + '(' + commit[:author][:login] + ")\n"
      end
  end
end

# .select { |commit| commit[:commit][:author][:date].to_date == Date.today-1||commit[:commit][:author][:date].to_date-1 == Date.today-2 ||commit[:commit][:author][:date].to_date-2 == Date.today-3}
