class Product < ApplicationRecord
  include Discard::Model

  validates_presence_of :description, :model
end
