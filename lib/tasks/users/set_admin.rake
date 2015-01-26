namespace :users do
  desc "Set admin user"
  task :set_admin, [:username] => :environment do |task, args|
    user = User.find_by_username(args[:username])
    if user
      user.default_role = 'admin'
      user.save
      puts "Done."
    else
      puts "Cannot find #{args[:username]}"
    end
  end
end
