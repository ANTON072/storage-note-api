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
require 'rails_helper'

RSpec.describe UserStorage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
