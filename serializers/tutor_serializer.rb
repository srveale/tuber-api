class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :education, :experience, :created_at
end