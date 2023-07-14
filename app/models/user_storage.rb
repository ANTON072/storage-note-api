# == Schema Information
#
# Table name: user_storages
#
#  id         :bigint           not null, primary key
#  role       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  storage_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_storages_on_storage_id  (storage_id)
#  index_user_storages_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (storage_id => storages.id)
#  fk_rails_...  (user_id => users.id)
#
class UserStorage < ApplicationRecord
  enum role: { member: 0, owner: 1 }

  belongs_to :user
  belongs_to :storage

  before_destroy :prevent_owner_removal, if: -> { role == :owner }

  validates :role, { presence: true }

  def self.create_member(user, storage)
    create(user:, storage:, role: :member)
  end

  def self.create_owner(user, storage)
    create(user:, storage:, role: :owner)
  end

  private

  def prevent_owner_removal
    # 自分がオーナーのレコードを検索して一件もなかったら処理を終了する
    throw :abort if UserStorage.where(storage:, role: :owner).count < 1
  end
end
