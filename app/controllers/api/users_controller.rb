class Api::UsersController < ApiController
	before_action :authenticated?

	def index
		users = User.all
		render json: users, each_serializer: UserSerializer 
		#render json: JSON.pretty_generate(users.as_json), each_serializer: UserSerializer # shows all detail
	end

	def show
		user = User.find(params[:id])
		#render json: user, each_serializer: UserSerializer
		render json: JSON.pretty_generate(UserSerializer.new(user).as_json)
		#render json: JSON.pretty_generate(user.as_json) # shows all detail
	end

end
