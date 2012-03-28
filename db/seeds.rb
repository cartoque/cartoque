# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Daley', city: cities.first)

#a DB connection
db = ActiveRecord::Base.connection

#create a first user if none
User.create!(name: "admin", email: "admin@example.net", password: "admin") if User.count == 0
