class Api::ListsController < ApiController
	before_action :authenticated?

	def create
		user = User.find(params[:user_id])
		list = user.lists.new(list_params)
		if list.save
			render json: list, status: 202 
		else
			render json: { error: list.errors.full_messages }, status: :unprocessable_entity
		end 
	end

	def destroy
		user = User.find(params[:user_id])
		list = user.lists.find(params[:id])
		list.destroy
		render json: {}, status: :no_content
	end

	private
	def list_params
		params.require(:list).permit(:name)
	end

end

