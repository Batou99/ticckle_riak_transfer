require 'rubygems'
require 'pry'
require 'active_record'

require './models/video'
require './models/topic'
require './models/user'
require './models/riak_topic'
require './models/riak_user'
require './models/riak_video'

puts "step 1: delete all"
RiakTopic.delete_all # Expensive, do not use on production
RiakUser.delete_all
RiakVideo.delete_all

puts "step 2: add topics"
Topic.all.each do |topic|
  uuids = topic.as_json[:videos].map { |v| v[:uuid] }
  t = RiakTopic.new(SecureRandom.hex,topic.as_json, { permalink: topic.permalink, uuid: uuids}) if topic.permalink
  t.save
end

puts "step 3: add users and videos"
User.all.each do |user|
  uuids = user.videos.map(&:uuid)
  u = RiakUser.find_by_index('username', user.username) || RiakUser.new(SecureRandom.hex, user.as_json, { username: user.username, video_uuids: uuids })
  user.videos.each do |video|
    v = RiakVideo.new(SecureRandom.hex,video.as_json, { uuid: video.uuid, state: video.state })
    t = RiakTopic.find_by_index('uuid', video.uuid)
    next unless t
    #binding.pry
    #puts video.uuid
    v.user = u
    v.topic = t
    v.save
    u.add_videos v
  end
  #binding.pry if user.username == 'xanblacker'
  u.save
end

puts "step 4: add some watches"

ru = RiakUser.find_by_index('username','xanblacker')

binding.pry
