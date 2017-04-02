class Api::UsersController < ApiController
	#before_action :authenticated?

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

	def create
		user = User.new(user_params)
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
			render json: {}, status: :no_content
#		rescue ActiveRecord::RecordNotFound
#			render :json => {}, status: :not_found
			#render json: { error: "RecordNotFound", status: 404 }, status: :not_found
#		end
	end	

	private
	def user_params
		params.require(:user).permit(:username, :password)
	end

end
