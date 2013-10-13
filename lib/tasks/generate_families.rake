# Generate some dummy families
namespace :families do
  desc "Pick a random user as the winner"
  task :random, [:count] => :environment do |t, args|
    
    args.with_defaults(:count => 10)

    count = args[:count].to_i


    count.times do

      fam = Family.new({
          last_name: Faker::Name.last_name,
          first_name: Faker::Name.first_name,
          phone: Faker::PhoneNumber.phone_number,
          address: Faker::Address.street_address,
          directions: Faker::Lorem.sentence(10),
          family_size: rand(5),
          children_size: rand(3)
        })
      fam.save


    end

  end
end