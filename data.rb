require 'rubygems'
require 'pry'
require 'active_record'

require './models/user'

File.open("data.csv", 'w') { |f|
  User.all.each do |u|
    f.write("#{u.id},#{u.avatar_url}\n")
  end
}
