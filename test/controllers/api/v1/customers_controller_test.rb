require "test_helper"

class Api::V1::CustomersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_customers_index_url
    assert_response :success
  end
end
