Mongoid.configure do |config|
  config.database = Mongo::Connection.new.db("mvui-#{Rails.env}")
  #config.database.authenticate(username,password)
end
