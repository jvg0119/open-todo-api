class Api::ListsController < ApiController
	#before_action :authenticated?
	before_action :set_user, only: [:index, :show, :create, :update, :destroy]
	before_action :set_list, only: [:show, :update, :destroy]
	before_action :authorized_user_for_list, only: [:index, :show, :creat, :update, :destroy]

	def index
		# @user = User.find(params[:user_id])
		@lists = @user.lists
		render json: @lists, each_serializer: ListSerializer
	end

	def show
		# @user = User.find(params[:user_id])
		# list = @user.lists.find(params[:id])
		render json: @list, each_serializer: ListSerializer
	 end

	def create
		# user = User.find(params[:user_id])
		# list = user.lists.new(list_params)
		list = @current_user.lists.new(list_params)
		if list.save
			render json: list, status: 202
		else
			render json: { error: list.errors.full_messages }, status: :unprocessable_entity
		end
	end

	def update
		#user = User.find(params[:user_id])
		#list = user.lists.find(params[:id])
		#byebug
		if @list.update(list_params)
			render json: @list
		else
			render json: { error: @list.errors.full_messages }, status: :unprocessable_entity
		end
	end

	def destroy
		#user = User.find(params[:user_id])
		#list = user.lists.find(params[:id])
		@list.destroy
	#	render json: {}, status: :no_content
		render json: { message: "List destroyed", status: 200 }, status: 200 # messages is shown as feedback for deleting
	end

	private
	def list_params
		params.require(:list).permit(:name, :permission)
	#	byebug
	end

	def set_user
		@user = User.find(params[:user_id])
	end

	def set_list
		#@list = List.find(params[:id])
		@list = @user.lists.find(params[:id])
	end

	def authorized_user_for_list
		unless @current_user == @user
			render json: { error: "Not authorized user.", status: 403 }, status: 403
		end
	end

end
