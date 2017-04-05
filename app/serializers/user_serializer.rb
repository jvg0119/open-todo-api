class UserSerializer < ActiveModel::Serializer
  attributes :id, :username#, :password, :auth_token
end
