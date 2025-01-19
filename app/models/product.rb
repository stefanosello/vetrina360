class Product < ApplicationRecord
  include Discard::Model

  validates_presence_of :description, :model
  has_one_attached :image
end
