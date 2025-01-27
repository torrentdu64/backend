require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  def setup
    @customer = Customer.new(first_name: "John", last_name: "Doe", email: "john@example.com", ip_address: "192.168.1.1")

    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  test "customer should be valid" do
    assert @customer.valid?
  end

  # Test for first_name validations
  test "first name should be present" do
    @customer.first_name = ""
    assert_not @customer.valid?
  end

  test "first name should not be too short" do
    @customer.first_name = "A"
    assert_not @customer.valid?
  end

  test "first name should not be too long" do
    @customer.first_name = "a" * 51
    assert_not @customer.valid?
  end

  # Test for last_name validations
  test "last name should be present" do
    @customer.last_name = ""
    assert_not @customer.valid?
  end

  test "last name should not be too short" do
    @customer.last_name = "A"
    assert_not @customer.valid?
  end

  test "last name should not be too long" do
    @customer.last_name = "a" * 51
    assert_not @customer.valid?
  end

  # Test for email validations
  test "email should be present" do
    @customer.email = ""
    assert_not @customer.valid?
  end

  test "email should be unique" do
    duplicate_customer = @customer.dup
    duplicate_customer.email = @customer.email.upcase
    @customer.save
    assert_not duplicate_customer.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @customer.email = valid_address
      assert @customer.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @customer.email = invalid_address
      assert_not @customer.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  # Test for ip_address validations
  test "ip address should be present" do
    @customer.ip_address = ""
    assert_not @customer.valid?
  end

  test "ip address should be a valid IPv4 address" do
    @customer.ip_address = "256.1.1.1" # Invalid because 256 > 255
    assert_not @customer.valid?

    @customer.ip_address = "192.168.1.1" # Valid
    assert @customer.valid?
  end
end