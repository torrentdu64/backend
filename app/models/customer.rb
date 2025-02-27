class Customer < ApplicationRecord
  # Mandatory fields
  # Validation for email
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }

  # Validation for ip_address
  validates :ip_address, presence: true, 
                         format: { with: /\A(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\z/,
                                   message: "should be a valid IPv4 address" }

  # Optional field
  validates :first_name, length: { minimum: 2, maximum: 50 }, allow_blank: true
  validates :last_name,  length: { minimum: 2, maximum: 50 }, allow_blank: true
  validates :company,    length: { minimum: 1, maximum: 50 }, allow_blank: true
  validates :city,       length: { minimum: 2, maximum: 100 }, allow_blank: true
  validates :title,      length: { minimum: 2, maximum: 100 }, allow_blank: true
  
  validates :website, format: { with: /\Ahttps?:\/\//i, message: "must be a valid URL", allow_blank: true }

end
