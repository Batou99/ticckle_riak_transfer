require 'risky'
Risky.riak = Riak::Client.new(:host => '10.0.2.15', :protocol => 'pbc')

class RiakVideo < Risky
  include Risky::Indexes
  include Risky::Timestamps
  include Risky::ListKeys
  include Risky::SecondaryIndexes

  bucket 'videos'

  value :title
  value :tags
  value :points
  value :length
  value :guid
  value :s3_key
  value :state

  index2i :uuid, type: :bin
  index2i :state, type: :bin

  link :user
  link :topic

end
