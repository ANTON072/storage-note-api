# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  storage_id :bigint           not null
#
# Indexes
#
#  index_categories_on_storage_id           (storage_id)
#  index_categories_on_storage_id_and_name  (storage_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (storage_id => storages.id)
#
require 'rails_helper'

RSpec.describe Category, type: :model do
  subject(:category) { FactoryBot.build(:category) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should belong_to(:storage) }
    it { should have_many(:stocks).dependent(:nullify) }
  end
end
