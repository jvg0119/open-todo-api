class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :created_at #, :password, :auth_token

  def created_at
  	object.created_at.strftime('%B %d, %Y')
  end

end
