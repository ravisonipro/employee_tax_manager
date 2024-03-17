# db/seeds.rb

# Clear existing data
Employee.destroy_all

puts "Old data is cleared"


# Generate sample employee data
10.times do
  date_of_joining = Faker::Date.between(from: 2.years.ago, to: Date.today)

  Employee.create(
    employee_id: "EMP#{Faker::Number.unique.number(digits: 4)}",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    phone_number: Faker::PhoneNumber.phone_number,
    date_of_joining: date_of_joining,
    salary: Faker::Number.between(from: 30000, to: 500000)
  )
end


puts "Dummy data created successfully!"
