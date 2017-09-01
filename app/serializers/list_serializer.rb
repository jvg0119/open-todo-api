class ListSerializer < ActiveModel::Serializer
  attributes :id, :name, :permission, :created_at

  def created_at
  	object.created_at.strftime('%B %d, %Y')
  end

end
