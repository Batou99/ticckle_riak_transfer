require 'risky'
Risky.riak = Riak::Client.new(:host => '10.0.2.15', :protocol => 'pbc')

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

  links :videos

end
