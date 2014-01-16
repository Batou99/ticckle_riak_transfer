require 'rubygems'
require 'pry'
require 'active_record'

require './models/video'
require './models/topic'
require './models/user'
require './models/riak_topic'
require './models/riak_user'

#Risky.riak.list_keys('topics').each do |key|
RiakTopic.delete_all # Expensive, do not use on production
Topic.all.each do |topic|
  uuids = topic.as_json[:videos].map { |v| v[:uuid] }
  t = RiakTopic.new(SecureRandom.hex,topic.as_json, { permalink: topic.permalink, uuid: uuids}) if topic.permalink
  t.save
end


binding.pry
