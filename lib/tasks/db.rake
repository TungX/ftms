namespace :db do
  desc "remake database data"
  task remake_data: :environment do
    Rake::Task["db:migrate:reset"].invoke
    puts "Creating User"
    Fabricate :user, email: "admin@tms.com", role: "admin"
    Fabricate :user, email: "supervisor@tms.com", role: "supervisor"
    15.times do
      Fabricate :user
    end
  end
end
