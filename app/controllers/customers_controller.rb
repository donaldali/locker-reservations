class CustomersController < ApplicationController
  def valid_identifier
    valid = !Customer.from_identifier(params[:reservation][:bags_owner]).nil?
    render json: valid
  end
end
