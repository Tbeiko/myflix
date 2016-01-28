# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = Category.create([{name: "Comedy"}, {name: "Science Fiction"}, {name: "Adult"}])


videos =  12.times do |video|
  video = Video.create
  video.title = "Family Guy"
  video.description = "Adventures of Peter's Family"
  video.small_cover_url = "/tmp/family_guy.jpg"
  video.large_cover_url = "/tmp/monk_large.jpg"
  video.category_id = 1
  video.save!
end

video = Video.create
video.title = "Families' Guys"
video.description = "Adventures of Peter's Family"
video.small_cover_url = "/tmp/family_guy.jpg"
video.large_cover_url = "/tmp/monk_large.jpg"
video.category_id = 1
video.save!

videos =  6.times do |video|
  video = Video.create
  video.title = "Futurama"
  video.description = "Fry wakes up in the future."
  video.small_cover_url = "/tmp/futurama.jpg"
  video.large_cover_url = "/tmp/monk_large.jpg"
  video.category_id = 2
  video.save!
end

videos =  6.times do |video|
  video = Video.create
  video.title = "South Park"
  video.description = "A gang of young teenagers go on reckless adventures."
  video.small_cover_url = "/tmp/south_park.jpg"
  video.large_cover_url = "/tmp/monk_large.jpg"
  video.category_id = 3
  video.save!
end

tim = User.create(name: "Tim BB", password: "password", email: "tim@bb.com")
video = Video.last 

Review.create(user: tim, video: video, rating: 3, content: "That was okay." )
Review.create(user: tim, video: video, rating: 2, content: "That was bad." )