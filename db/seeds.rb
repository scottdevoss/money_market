# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d market_money_development db/data/market_money_development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)

# 10.times do
#   Market.create!(
#     name: Faker::Company.name,
#     street: Faker::Address.street_address,
#     city: Faker::Address.city,
#     county: Faker::Address.city,
#     state: Faker::Address.state,
#     zip: Faker::Address.zip,
#     lat: Faker::Address.latitude,
#     lon: Faker::Address.longitude
#   )
# end

# 5.times do 
#   Vendor.create!(
#     name: Faker::Company.name,
#     description: Faker::Lorem.sentence,
#     contact_name: Faker::Name.name,
#     contact_phone: Faker::PhoneNumber.phone_number,
#     credit_accepted: Faker::Boolean.boolean
#   )
# end

# markets = Market.all

# markets.each do |market|
#   vendor_id_1 = rand(1..5)
#   vendor_id_2 = rand(1..5)

#   MarketVendor.create!([
#     {
#       market_id: market.id,
#       vendor_id: vendor_id_1
#     },
#     {
#       market_id: market.id,
#       vendor_id: vendor_id_2
#     }
#   ])
# end