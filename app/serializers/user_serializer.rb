class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :token, :created_at
end
