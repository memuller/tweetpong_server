class TweetPong
  %w(stage object ball game player stage_objects).each{|lib| require "tweetpong/#{lib}"}
end

