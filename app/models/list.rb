class List < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy
  validates :name, presence: true
  validates :permission, inclusion: { in: %w(private_list public_list),
    										message: "%{value} is not a valid permission" } 
  enum permission: { private_list: 0, public_list: 1 }
  after_initialize :set_permission

  def set_permission
  	self.permission ||= :private_list 
  end

end
