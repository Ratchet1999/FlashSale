desc "Generates Token"
namespace :user do
  task :generate_token  => :environment do |t, args|
    User.where(auth_token: nil).each(&:generate_auth_token)
  end
end
