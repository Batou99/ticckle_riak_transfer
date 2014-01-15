require 'risky'
Risky.riak = Riak::Client.new(:host => '10.0.2.15', :protocol => 'pbc')

class RiakTopic < Risky
  include Risky::Indexes
  include Risky::Timestamps

  bucket 'users' 

  value :username
  value :email

  value :updated_at, :class => Time
  value :created_at, :class => Time

end
