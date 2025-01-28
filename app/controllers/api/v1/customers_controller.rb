class Api::V1::CustomersController < ApplicationController
  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 20
    
    # Assuming you're using ActiveRecord for pagination
    customers = Customer.order(:id).page(page).per(per_page)
    
    # Render the customers as JSON
    render json: {
      customers: customers,
      pagination: {
        current_page: customers.current_page,
        next_page: customers.next_page,
        prev_page: customers.prev_page,
        total_pages: customers.total_pages,
        total_count: customers.total_count
      }
    }
  end
end
