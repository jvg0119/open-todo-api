class ApiController < ApplicationController
	skip_before_action :verify_authenticity_token

	before_action :authenticate_user

	rescue_from ActiveRecord::RecordNotFound, with: :not_found
	rescue_from ActionController::ParameterMissing, with: :malformed_request

#	private
	# def authenticated?
	# 	authenticate_or_request_with_http_basic { |username, password| User.where(username: username, password: password).present? }
	# end

	def authenticate_user
		authenticate_or_request_with_http_token do |token, options|
			@current_user = User.find_by(auth_token: token) #if User.exist?(token: token)
		end
	end

	def authorized_user # only admin is authorized_user
		unless @current_user && @current_user.admin?
			render json: { error: "Not Authorized!", status: 403 }, status: 403
		end
	end

	private
	def not_found
		render json: { error: "Record not found", status: 404 }, status: 404
	end

	def malformed_request
		render json: { error: "The request could not be understood by the server due to malformed syntax. The client SHOULD NOT repeat the request without modifications.", status: 400 }, status: 400
	end

	def authorized_user?(user)
		(@current_user == user) || @current_user.admin?
	end

end
