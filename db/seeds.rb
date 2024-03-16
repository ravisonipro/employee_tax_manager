# db/seeds.rb

# Clear existing data
Employee.destroy_all

# Generate dummy employee data
10.times do |i|
  Employee.create!(
    employee_id: "EMP#{i + 1}",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    phone_number: [Faker::PhoneNumber.phone_number, Faker::PhoneNumber.phone_number],
    date_of_joining: Faker::Date.between(from: 2.years.ago, to: Date.today),
    salary: Faker::Number.between(from: 50000, to: 150000)
  )
end

puts "Dummy data created successfully!"