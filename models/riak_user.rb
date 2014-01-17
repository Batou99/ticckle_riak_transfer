class RiakUser < Risky
  include Risky::Indexes
  include Risky::Timestamps
  include Risky::ListKeys
  include Risky::SecondaryIndexes

  bucket 'users' 

  value :username
  value :email

  value :updated_at, :class => Time
  value :created_at, :class => Time


  index2i :username, type: :bin
  index2i :video_uuids, type: :bin, multi: true
  index2i :watcher_ids, type: :bin, multi: true

  links :videos

  def list_videos
    @riak_object.walk('videos','videos',true).flatten.map(&:data).map { |v| v.delete 'user'; v}
  end

  def watch_user!(user)
    add_watcher!(user)
  end

  def unwatch_user!(user)
    remove_watcher!(user)
  end

  def watch_debate!(topic)
    add_watcher!(topic)
  end

  def unwatch_debate!(topic)
    remove_watcher!(topic)
  end

  def topics
    RiakTopic.find_by_index('contributors',self.id)
  end

  def my_ticckle
    topics = RiakTopic.find_all_by_index('watcher_ids',self.id)
    users = RiakUser.find_all_by_index('watcher_ids',self.id)
    users.each do |user|
      topics << user.topics
    end
    topics.uniq.delete_if { |x| x==nil }
  end

  private
  def add_watcher!(watched)
    ids = (watched.watcher_ids << self.id).uniq
    watched.watcher_ids = ids
    watched.save
  end

  def remove_watcher!(watched)
    ids = watched.watcher_ids - [self.id]
    watched.watcher_ids = ids
    watched.save
  end
end
