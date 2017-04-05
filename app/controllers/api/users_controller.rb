class Api::UsersController < ApiController
	#before_action :authenticated?

	def index
		@users = User.all
		render json: @users, each_serializer: UserSerializer, status: 200 
		#render json: JSON.pretty_generate(users.as_json), each_serializer: UserSerializer # shows all detail
	end

	def show
		@user = User.find(params[:id])
		#render json: @user.to_json, each_serializer: UserSerializer
		render json: @user, status: 200
		#render json: JSON.pretty_generate(UserSerializer.new(user).as_json)
		#render json: JSON.pretty_generate(user.as_json) # shows all detail
	end

	def create
		#byebug
		user = User.new(user_params)
		#byebug
		if user.save
			render json: user
		else
			render json: { error: user.errors.full_messages }, status: :unprocessable_entity
			# error: shows on the terminal;   status:  shows on the log
		end
	end

	def destroy
#		begin
			user = User.find(params[:id])
			user.destroy
			#render json: {}, status: :no_content
			render json: { message: "User destroyed", status: 200 }, status: 200
#		rescue ActiveRecord::RecordNotFound
#			render :json => {}, status: :not_found
			#render json: { error: "RecordNotFound", status: 404 }, status: :not_found
#		end
	end	

	private
	def user_params
		params.require(:user).permit(:username, :password, :auth_token)
	end

end
