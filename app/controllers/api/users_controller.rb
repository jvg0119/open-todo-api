class Api::UsersController < ApiController
	#before_action :authenticated?
	skip_before_action :authenticate_user, only: [:create] # no sign in to create a user
	before_action :authorized_user, only: [:index] # only admin can view all users

	def index
		@users = User.all
		render json: @users, each_serializer: UserSerializer, status: 200
		#render json: JSON.pretty_generate(users.as_json), each_serializer: UserSerializer # shows all detail
	end

	def show
		@user = User.find(params[:id])
		if authorized_user?(@user)
			#byebug
			#render json: @user.to_json, each_serializer: UserSerializer
			render json: @user, status: 200
			#render json: JSON.pretty_generate(UserSerializer.new(user).as_json)
			#render json: JSON.pretty_generate(user.as_json) # shows all detail
		else
			render json: { error: "Not Authorized! *** ", status: 403 }, status: 403
		end
	end

	def create
		#byebug
		user = User.new(user_params)
		if user.save
			render json: user
		else
			render json: { error: user.errors.full_messages }, status: :unprocessable_entity
			# error: shows on the terminal;   status:  shows on the log
		end
	end

	def destroy
			@user = User.find(params[:id])
			if authorized_user?(@user)
				@user.destroy
				render json: {message: "User deleted", status: :no_content}, status: :no_content # 204
			else
				render json: { error: "Not Authorized! *** ", status: 204 }, status: 204
			end
	end

	private
	def user_params
		params.require(:user).permit(:username, :password, :auth_token)
	end

end
