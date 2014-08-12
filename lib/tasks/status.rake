namespace :status do
  desc "Update cache with latest data from MTA"
  task :update => :environment do
  	update_cache
  end
end
