
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    require 'faker'

    users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end
  end
end