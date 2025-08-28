case Rails.env
when "development"
  load Rails.root.join("db/seeds/development.rb")
when "production"
  load Rails.root.join("db/seeds/production.rb") if File.exist?(Rails.root.join("db/seeds/production.rb"))
end