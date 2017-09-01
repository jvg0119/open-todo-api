class User < ApplicationRecord
	has_many :lists, dependent: :destroy
	validates :username, :password, presence: true

	before_create :generate_auth_token 

	enum role: { regular: 0, admin: 1 }

  before_validation { self.role ||= :regular }

	def generate_auth_token
    loop do
      self.auth_token = SecureRandom.base64(64)
      break unless User.find_by(auth_token: auth_token)
    end
    # self.auth_token ||= SecureRandom.base64(64)
  end

end
