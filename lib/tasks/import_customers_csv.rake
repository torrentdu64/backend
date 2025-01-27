namespace :csv do
  desc "Import data from a CSV file into the database, be-dev-test/data should be at same level as backend file" 
  task import_customers: :environment do
    require 'csv'

    file_path = "../be-dev-test/data/#{ENV['NAME']}" # run in term rake csv:import_customers NAME=customers.csv
    if file_path.blank?
      puts "Please provide the CSV file include to be-dev-test/data folder"
      exit
    end

    CSV.foreach(file_path, headers: :first_row) do |row|
      user_data = {
        first_name: row['first_name'],
        last_name: row['last_name'],
        email: row['email'],
        gender: row['gender'],
        ip_address: row['ip_address'],
        company: row['company'],
        city: row['city'],
        title: row['title'],
        website: row['website']
      }

      if user_data[:email].empty?
        raise "customer email missing for: #{user_data.inspect} "
      end

     
      # user = User.find_or_initialize_by(email: user_data[:email])
      # user.update!(user_data)
    end

    puts "CSV import complete!"
  end
end
