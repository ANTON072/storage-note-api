# == Schema Information
#
# Table name: stocks
#
#  id            :bigint           not null, primary key
#  description   :string
#  image_url     :string
#  item_count    :integer          not null
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  category_id   :bigint           not null
#  created_by_id :bigint           not null
#  storage_id    :bigint           not null
#  updated_by_id :bigint           not null
#
# Indexes
#
#  index_stocks_on_category_id    (category_id)
#  index_stocks_on_created_by_id  (created_by_id)
#  index_stocks_on_name           (name)
#  index_stocks_on_storage_id     (storage_id)
#  index_stocks_on_updated_by_id  (updated_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (storage_id => storages.id)
#  fk_rails_...  (updated_by_id => users.id)
#
require 'rails_helper'

RSpec.describe Stock, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
