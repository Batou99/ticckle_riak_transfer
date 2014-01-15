require 'rubygems'
require 'pry'
require 'active_record'

require './models/video'
require './models/topic'
require './models/riak_topic'

#Risky.riak.list_keys('topics').each do |key|
Topic.all.each do |topic|
  puts topic.permalink
  RiakTopic.new(SecureRandom.hex,topic.as_json, permalink: topic.permalink).save if topic.permalink
end


binding.pry
