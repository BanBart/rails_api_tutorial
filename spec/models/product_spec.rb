require 'spec_helper'

describe Product do
  let(:product) { FactoryGirl.create(:product) }
  subject { product }

  it { should respond_to(:title, :price, :published, :user_id) }

  it { should_not be_published }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:user_id) }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

  it { should belong_to :user}

end
