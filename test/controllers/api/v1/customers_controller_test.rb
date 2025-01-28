require "test_helper"

class Api::V1::CustomersControllerTest < ActionDispatch::IntegrationTest
  # Setup some test data
  def setup
    @customers = []
    30.times do |n|
      @customers << Customer.create!(
        first_name: "Customer#{n}",
        last_name: "LastName#{n}",
        email: "customer#{n}@example.com",
        ip_address: "192.168.1.#{n}"
      )
    end
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  test "should get index with default pagination" do
    get api_v1_customers_path
  
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 20, json_response['customers'].size, "Expected 20 customers on the first page"
    assert_equal 1, json_response['pagination']['current_page']
    assert_equal 2, json_response['pagination']['total_pages'] # Assuming 32 customers / 20 per page = 2 pages
    assert_equal 32, json_response['pagination']['total_count']
  end

  test "should get first page of customers" do
    get api_v1_customers_path, params: { page: 1, per_page: 10 }
  
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 10, json_response['customers'].size, "Expected 10 customers on the first page"
    assert_equal 1, json_response['pagination']['current_page']
    assert_equal 4, json_response['pagination']['total_pages']
    assert_equal 32, json_response['pagination']['total_count']
  end

  test "should get second page of customers" do
    get api_v1_customers_path, params: { page: 2, per_page: 10 }
  
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 10, json_response['customers'].size, "Expected 10 customers on the second page"
    assert_equal 2, json_response['pagination']['current_page']
    assert_equal 1, json_response['pagination']['prev_page']
    assert_equal 3, json_response['pagination']['next_page']
    assert_equal 4, json_response['pagination']['total_pages'] # Update from 3 to 4
  end

  test "should handle out-of-range pages" do
    get api_v1_customers_path, params: { page: 4, per_page: 10 }
  
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 2, json_response['customers'].size, "Expected 2 customers on the last page"
    assert_equal 4, json_response['pagination']['current_page']
    assert_equal 3, json_response['pagination']['prev_page']
    assert_nil json_response['pagination']['next_page']
    assert_equal 4, json_response['pagination']['total_pages']
  end
end

