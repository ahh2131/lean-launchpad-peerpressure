require 'rails_helper'
describe User do
	it "has a valid factory" do
		expect(FactoryGirl.build(:user)).to be_valid
	end
	it "is invalid without an email" do
		expect{FactoryGirl.create(:user, email: nil)}.to raise_error
	end
	it "is valid without a name" do
		expect(FactoryGirl.build(:user, name: nil)).to be_valid
	end
	it "is invalid without a password" do
		expect{FactoryGirl.create(:user, password: nil)}.to raise_error
	end
end