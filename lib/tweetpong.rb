class TweetPong
  %w(stage object ball game plataform player wall).each{|lib| require "tweetpong/#{lib}"}
end

