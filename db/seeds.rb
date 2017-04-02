# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts
# users
p joe = User.create(username: "joe", password: "password")
p mike = User.create(username: "mike", password: "password")
p jimmy = User.create(username: "jimmy", password: "password")
p lisa = User.create(username: "lisa", password: "password")
p kelly = User.create(username: "kelly", password: "password")

puts
# lists 
p joe_list1 = List.create(name: "#{joe.username}'s todo list #1", user: joe)
p joe_list2 = List.create(name: "#{joe.username}'s todo list #2", user: joe)
p mike_list1 = List.create(name: "#{mike.username}'s todo list #1", user: mike)
p mike_list2 = List.create(name: "#{mike.username}'s todo list #2 ", user: mike)

puts
# items
1.upto(5) do |n| 
	p Item.create(description: "item #{n} on #{joe_list1.user.username}'s #1 list" , list: joe_list1)
end

puts
1.upto(5) do |n| 
	p Item.create(description: "item #{n} on #{joe_list2.user.username}'s #2 list" , list: joe_list2)
end

puts
1.upto(5) do |n| 
	p Item.create(description: "item #{n} on #{mike_list1.user.username}'s #1 list" , list: mike_list1)
end

puts
1.upto(5) do |n| 
	p Item.create(description: "item #{n} on #{mike_list2.user.username}'s #2 list" , list: mike_list2)
end

puts
puts "*".center(40,"*")
puts
puts " done seeding ".center(40)
puts " #{User.count} users created ".center(40)
puts " #{List.count} lists created ".center(40)
puts " #{Item.count} items created ".center(40) 
puts 
puts "*".center(40,"*")


