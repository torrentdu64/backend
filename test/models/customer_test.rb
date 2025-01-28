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
  test "first name can be blank or nil" do
    @customer.first_name = ""
    assert @customer.valid?

    @customer.first_name = nil
    assert @customer.valid?
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
  test "last name can be blank or nil" do
    @customer.last_name = ""
    assert @customer.valid?

    @customer.last_name = nil
    assert @customer.valid?
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


  # Test for company length validation
  test "company should not be too long" do
    @customer.company = "a" * 51
    assert_not @customer.valid?
  end

  # Test for city length validation
  test "city should not be too long" do
    @customer.city = "a" * 101
    assert_not @customer.valid?
  end

  # Test for title length validation
  test "title should not be too long" do
    @customer.title = "a" * 101
    assert_not @customer.valid?
  end

  # Test for website validation
  test "website should be a valid URL if present" do
    @customer.website = "not-a-url"
    assert_not @customer.valid?

    @customer.website = "http://example.com"
    assert @customer.valid?

    @customer.website = "https://example.com"
    assert @customer.valid?

    @customer.website = ""
    assert @customer.valid? # Since we allow_blank: true
  end

  # Test to ensure all mandatory fields are present
  test "all mandatory fields should be present" do
    mandatory_fields = [:email, :ip_address]

    mandatory_fields.each do |field|
      @customer.send("#{field}=", nil)
      assert_not @customer.valid?, "#{field} should be required"
      @customer.send("#{field}=", "some_value") # Reset for next test
    end
  end

  # Test to ensure optional fields can be blank or nil
  test "optional fields can be blank or nil" do
    optional_fields = [:first_name, :last_name, :company, :city, :title, :website]

    optional_fields.each do |field|
      @customer.send("#{field}=", nil)
      assert @customer.valid?, "#{field} should not be required"
      @customer.send("#{field}=", "") # Testing for blank strings as well
      assert @customer.valid?, "#{field} should allow blank strings"
    end
  end
end