class UserStorage < ApplicationRecord
  belongs_to :user
  belongs_to :storage
end
