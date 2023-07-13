class Item < ApplicationRecord
  belongs_to :storage
  belongs_to :category
  belongs_to :updated_by
  belongs_to :created_by
end
