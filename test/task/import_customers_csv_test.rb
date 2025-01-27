require 'test_helper'
require 'rake'

class CsvImportUsersTaskTest < ActiveSupport::TestCase
  def setup
    Rake.application.rake_require 'tasks/import_customers_csv' 
    Rake::Task.define_task(:environment) 

    @csv_dir = Rails.root.join('..', 'be-dev-test', 'data') 
    FileUtils.mkdir_p(@csv_dir)

    @csv_file_path = @csv_dir.join('customers.csv')
    File.write(@csv_file_path, csv_content)
  end

  def csv_content
    <<~CSV
      first_name,last_name,email,gender,ip_address,company,city,title,website
      Laura,Richards,lrichards0@reverbnation.com,Female,81.192.7.99,Meezzy,Kallithéa,Biostatistician III,https://intel.com
      Margaret,Mendoza,mmendoza1@sina.com.cn,Female,193.204.172.141,Skipfire,Jiashi,VP Marketing,http://printfriendly.com
    CSV
  end

  def test_it_imports_users_from_a_csv_file
    ENV['NAME'] = 'customers.csv'

    assert_difference 'Customer.count', 2 do
      Rake::Task['csv:import_customers'].invoke
    end

    user = Customer.find_by(email: 'lrichards0@reverbnation.com')
    assert_equal 'Laura', user.first_name
    assert_equal 'Richards', user.last_name
    assert_equal 'Meezzy', user.company
  end
end
