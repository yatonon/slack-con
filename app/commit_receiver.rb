require 'octokit'
require 'byebug'
require 'tapp'
require 'date'
require 'dotenv'

# コメント取ってくる
class CommitReceiver
  attr_accessor :message
  def initialize
    @message = ''
    Dotenv.load
    client = Octokit::Client.new login: ENV['LOGIN'], password:ENV['PASSWORD']
    commitlist = client.commits ENV['REPOSITORI']
    if Date.today.wday == 1
      for num in 1..3 do
        commitlist
          .select { |commit| commit[:commit][:author][:date].to_date == Date.today-num }
          .each.with_index(1) do |commit, index|
            @message << index.to_s + '.' + commit[:commit][:message].gsub(/\*(.*?)\n/,'') \
            .gsub(/(\r\n?|\n)/,"") +'(' + commit[:author][:login] + ")\n"
          end
      end
    else
      commitlist
      .select { |commit| commit[:commit][:author][:date].to_date == Date.today-1 }
      .each.with_index(1) do |commit, index|
        @message << index.to_s + '.' + commit[:commit][:message].gsub(/\*(.*?)\n/,'') \
        .gsub(/(\r\n?|\n)/,"") +'(' + commit[:author][:login] + ")\n"
      end
    end
  end
end
