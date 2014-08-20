require 'rails_helper'
describe Activity do
	it 'is invalid without an activity_type' do
		expect{FactoryGirl.create(:activity)}.to raise_error
	end
	it 'is invalid without a product object if add' do
		FactoryGirl.create(:user, :id => 1)
		product = FactoryGirl.create(:product)
		expect(FactoryGirl.build(:add_activity, :product_id => product.id)
		).to be_valid
	end
	it 'is valid without product_id if list' do
		expect(FactoryGirl.build(:list_activity, :list_id => 1)).to be_valid

	end
	it 'is invalid without fromUser' do
		expect{FactoryGirl.create(:seen_activity, :fromUser => nil)}.to raise_error
	end
	it 'is invalid without list_id if list' do
		product = FactoryGirl.create(:product)
		expect{FactoryGirl.create(:list_activity, :product_id => product.id)}.to raise_error
	end
	it 'is invalid without both from/toUser if follow' do
		product = FactoryGirl.create(:product)
		expect{FactoryGirl.create(:follow_activity, :toUser => nil, :product_id => product.id)}.to raise_error
	end
	it 'is invalid if toUser does not exist in follow activity' do
		product = FactoryGirl.create(:product)
		expect{FactoryGirl.create(:follow_activity, :toUser => 100000, :product_id => product.id)}.to raise_error
	end
	it 'is invalid if user already seen product' do
		product = FactoryGirl.create(:product)
		FactoryGirl.create(:seen_activity, :product_id => product.id, :fromUser => 1)
		expect{FactoryGirl.create(:seen_activity, :product_id => product.id, :fromUser => 1)}
		.to raise_error
	end
end