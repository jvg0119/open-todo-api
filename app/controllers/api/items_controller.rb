class Api::ItemsController < ApiController
	before_action :authenticated?

	def create
		list = List.find(params[:list_id])
		item = list.items.new(item_params)
		if item.save
			render json: item, status: 202
		else
			render json: { error: item.errors.full_messages }, status: :unprocessable_entity
		end
	end

	private
	def item_params
		params.require(:item).permit(:description)
	end

end

