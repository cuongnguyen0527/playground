20.times do |i|
  Staff.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 65),
    point: Faker::Number.number(digits: 3)
  )
end
