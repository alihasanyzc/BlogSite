# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create categories
categories = [
  "Technology",
  "Travel",
  "Food",
  "Health",
  "Sports",
  "Music",
  "Books",
  "Movies",
  "Photography",
  "Art"
]

categories.each do |category_name|
  Category.find_or_create_by(name: category_name)
end

puts "Created #{Category.count} categories"

# Create sample users (only if no users exist)
if User.count == 0
  user1 = User.create!(
    username: "john_doe",
    email: "john@example.com",
    password: "password123",
    password_confirmation: "password123"
  )
  user1.create_profile(bio: "I love writing about technology and travel.")

  user2 = User.create!(
    username: "jane_smith",
    email: "jane@example.com",
    password: "password123",
    password_confirmation: "password123"
  )
  user2.create_profile(bio: "Food blogger and photography enthusiast.")

  puts "Created #{User.count} users"
end
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
