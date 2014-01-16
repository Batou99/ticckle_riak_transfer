require 'risky'
Risky.riak = Riak::Client.new(:host => '10.0.2.15', :protocol => 'pbc')

class RiakTopic < Risky
  include Risky::Indexes
  include Risky::Timestamps
  include Risky::ListKeys
  include Risky::SecondaryIndexes

  bucket 'topics' 

  value :discussion
  value :points
  value :tags
  value :views_count
  value :permalink
  value :popularity

  def before_save
    days = (Time.now - updated_at || Time.now).to_i / 1.day
    self.popularity = days / (1.0 + points)
  end

  value :updated_at, :class => Time
  value :created_at, :class => Time

  value :videos, default: {}

  index2i :permalink, type: :bin
  index2i :uuid, type: :bin, multi: true

end
