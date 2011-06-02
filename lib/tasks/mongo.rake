namespace :db do
  namespace :test do
    task :prepare do
      # Stub out for MongoDB
    end
  end
end

# TODO more indexes please
task :build_indexes => :environment do
  puts "Building indexes for Asset"
  drop_indexes_on(Asset)
  Asset.ensure_index [['random_number', 1]]
  
end

def drop_indexes_on(model)
  model.collection.drop_indexes if model.count > 0
end