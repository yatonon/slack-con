require 'octokit'
require 'byebug'
require 'tapp'
require 'date'
require 'dotenv'

# コメント取ってくる
class CommitReceiver
  attr_accessor :message
  def commit_get

    def make_date_diffs(*arr)
      arr.map{ |elem| Date.today - elem }
    end

    @message = ''
    Dotenv.load
    client = Octokit::Client.new login: ENV['LOGIN'], password:ENV['PASSWORD']
    commitlist = client.commits ENV['REPOSITORI']
    compare_list = Date.today.wday == 1 ? make_date_diffs(1, 2, 3) : make_date_diffs(1)
    index = 1

    commitlist.each do |commit|
      if compare_list.include?(commit[:commit][:author][:date].to_date)
        formated_message = commit[:commit][:message].gsub(/\*(.*?)\n/,'')
          .gsub(/(\r\n?|\n)/,'')
        author = commit[:author][:login]
        @message += "#{index}. #{formated_message}(#{author})\n"
        index += 1
        end
      end

  end

end
