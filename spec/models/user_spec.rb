require 'rails_helper'

RSpec.describe User, type: :model do

  describe User do
    #有効なファクトリを持つこと
    it "has a valid factory" do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end
    #姓、名、メール、パスワードがあれば有効な状態であること
    # it "isvalid with a first name, last name, email ,and password" do
    #   user = User.new(
    #     first_name: "Aaron",
    #     last_name: "Sumner",
    #     email: "tester40@example.com",
    #     password: "dottle-nouveau-pavilion-tights-furze"
    #   )
    #   expect(user).to be_valid
    # end

  #名がなければ無効な状態であること
  it "is invalid without a firstname" do
    user = FactoryBot.build(:user, first_name: nil)
    # user = User.new(first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  #姓がなければ無効な状態であること
  it "is invalid without a lastname" do
    user = FactoryBot.build(:user, last_name: nil)
    # user = User.new(last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  #メールアドレスがなければ無効な状態であること
  it "is invalid without an email address" do
    user = FactoryBot.build(:user, email: nil)
    # user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  #重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    FactoryBot.create(:user, email: "aaron@example.com")
    user = FactoryBot.build(:user, email: "aaron@example.com")
    # User.create(
    #   first_name: "Joe",
    #   last_name: "Tester",
    #   email: "tester@example.com",
    #   password: "abc123",
    # )
    # user = User.new(
    #   first_name: "Jane",
    #   last_name: "Tester",
    #   email: "tester@example.com",
    #   password: "abc123",
    # )
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  #ユーザーのフルネームを文字列として返すこと
  it "returns a user's full name as a string" do
    user = FactoryBot.build(:user, first_name: "Joe", last_name: "Tester")
    # user = User.new(
    #   first_name: "Joe",
    #   last_name: "Tester",
    #   email: "tester@example.com",
    #   password: "abc123",
    # )
    expect(user.name).to eq "Joe Tester"
  end

end
