require 'rubygems'
require 'pry'
require 'active_record'
require 'risky'
Risky.riak = Riak::Client.new(:host => '10.0.2.15')#, :protocol => 'pbc')


require './models/video'
require './models/topic'
require './models/user'
require './models/riak_topic'
require './models/riak_user'
require './models/riak_video'

def step1
  puts "step 1: delete all"
  RiakTopic.delete_all # Expensive, do not use on production
  RiakUser.delete_all
  RiakVideo.delete_all
end

def step2
  puts "step 2: add topics"
  Topic.all.each do |topic|
    uuids = topic.as_json[:videos].map { |v| v[:uuid] }
    t = RiakTopic.new(SecureRandom.hex,topic.as_json, { permalink: topic.permalink, uuid: uuids, watcher_ids: [], contributors: []}) if topic.permalink
    t.save
  end
end

def step3
  puts "step 3: add users and videos"
  User.all.each do |user|
    uuids = user.videos.map(&:uuid)
    u = RiakUser.find_by_index('username', user.username) || RiakUser.new(SecureRandom.hex, user.as_json, { username: user.username, video_uuids: uuids, watcher_ids: []})
    user.videos.each do |video|
      v = RiakVideo.new(SecureRandom.hex,video.as_json, { uuid: video.uuid, state: video.state })
      t = RiakTopic.find_by_index('uuid', video.uuid)
      next unless t
      #binding.pry
      #puts video.uuid
      v.user = u
      v.topic = t
      t.contributors << u
      t.save
      v.save
      u.add_videos v
    end
    #binding.pry if user.username == 'xanblacker'
    u.save
  end
end

def step4
  puts "step 4: add some watches"

  topics = RiakTopic.all[0..1]
  uuid = topics[0].videos.first["uuid"]
  users = [RiakUser.find_by_index('video_uuids',uuid), RiakUser.all[0]] 



  ru = RiakUser.find_by_index('username','xanblacker')
  ru.watch_debate!(topics[0])
  ru.watch_debate!(topics[1])
  ru.watch_user!(users[0])
  ru.watch_user!(users[1])
  ru
end

#step1
#step2
#step3
ru = step4


binding.pry
