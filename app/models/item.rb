class Item < ApplicationRecord
  belongs_to :list
  validates :description, length: { minimum: 10 }, presence: true
end
