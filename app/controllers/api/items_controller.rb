class Api::ItemsController < ApiController
	#before_action :authenticated?
	before_action :set_list, only: [:index, :show, :create, :update, :destroy]
	before_action :set_item, only: [:show, :update, :destroy]
	before_action :authorized_user, only: [:update, :destroy]

	def index 
		#list = List.find(params[:list_id])
		@items = @list.items
		#render json: @items, each_serializer: ItemSerializer
		render json: JSON.pretty_generate(@items.as_json) 
	end

	def show
		#list = List.find(params[:list_id])
		#item = list.items.find(params[:id])
		render json: @item, each_serializer: ItemSerializer
	end

	def create
		#list = List.find(params[:list_id])
		@list.user = @current_user
		@item = @list.items.new(item_params)
		if @item.save
			render json: @item, status: 202
		else
			render json: { error: @item.errors.full_messages }, status: :unprocessable_entity
		end
	end

	def update
		#list = List.find(params[:list_id])
		#item = list.items.find(params[:id])
		if @item.update(item_params)
			render json: @item 
		else
			render json: { error: @item.errors.full_messages }, status: :unprocessable_entity
		end
	end

	private
	def item_params
		params.require(:item).permit(:description, :completed)
	end

	def set_list
		@list = List.find(params[:list_id])
	end

	def set_item
		@item = @list.items.find(params[:id])
	end

	def authorized_user
		unless @current_user == @list.user
			render json: { error: "Not authorized user.", status: 403 }, status: 403
		end
	end	

end


