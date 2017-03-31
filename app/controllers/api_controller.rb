class ApiController < ApplicationController
	skip_before_action :verify_authenticity_token

	rescue_from ActiveRecord::RecordNotFound, with: :not_found

	private
	def authenticated?
		authenticate_or_request_with_http_basic { |username, password| User.where(username: username, password: password).present? }
	end

	def not_found
		render json: { error: "Record not found", status: 404 }, status: 404
	end	

end
