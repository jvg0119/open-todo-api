class User < ApplicationRecord
	has_many :lists, dependent: :destroy
	validates :username, :password, presence: true
end
