require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "validates uniqueness of nickname" do
      user = User.create(email: "test@example.com", password: "password", nickname: "testnick")
      duplicate_user = User.new(email: "duplicate@example.com", password: "password", nickname: "testnick")
      expect(duplicate_user).not_to be_valid
    end
  end
  describe "associations" do
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:comments) }
    it { should have_many(:likes) }
    it { should have_many(:active_relationships).class_name("Relationship").with_foreign_key("follower_id").dependent(:destroy) }
    it { should have_many(:passive_relationships).class_name("Relationship").with_foreign_key("followed_id").dependent(:destroy) }
    it { should have_many(:following).through(:active_relationships).source(:followed) }
    it { should have_many(:followers).through(:passive_relationships).source(:follower) }
  end

  describe "#follow" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it "follows another user" do
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy
    end

    it "does not follow oneself" do
      user.follow(user)
      expect(user.following?(user)).to be_falsey
    end
  end

  describe "#display_name" do
    let(:user_with_nickname) { create(:user, nickname: "testnick") }
    let(:user_without_nickname) { create(:user, nickname: nil, email: "test@example.com") }

    it "returns nickname if present" do
      expect(user_with_nickname.display_name).to eq("testnick")
    end

    it "returns email if nickname is absent" do
      expect(user_without_nickname.display_name).to eq("test@example.com")
    end
  end

  describe "#unfollow" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      user.follow(other_user)
    end

    it "unfollows another user" do
      user.unfollow(other_user)
      expect(user.following?(other_user)).to be_falsey
    end
  end

  describe "#relationship_with" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      user.follow(other_user)
    end

    it "returns the relationship with another user" do
      expect(user.relationship_with(other_user)).to be_present
    end
  end

  describe "#feed" do
    let(:user) { create(:user) }
    let(:followed_user) { create(:user) }
    let(:unfollowed_user) { create(:user) }

    before do
      # Пользователь создает пост
      create(:post, user: user)

      # Подписанный пользователь создает пост
      create(:post, user: followed_user)

      # Неподписанный пользователь создает пост
      create(:post, user: unfollowed_user)

      # Пользователь подписывается на другого пользователя
      user.follow(followed_user)
    end

    it "includes posts from followed users" do
      expect(user.feed).to include(followed_user.posts.first)
    end

    it "includes own posts" do
      expect(user.feed).to include(user.posts.first)
    end

    it "doesn't include posts from unfollowed users" do
      expect(user.feed).not_to include(unfollowed_user.posts.first)
    end
  end

  describe "#resize_avatar" do
    let(:user) { create(:user) }

    before do
      # Предположим, у пользователя есть аватар
      allow(user).to receive(:avatar).and_return(double(attached?: true))
    end

    it "resizes avatar to 64x64" do
      expect(user.avatar).to receive(:variant).with(resize: "64x64").and_return(double(processed: true))
      user.send(:resize_avatar)
    end
  end
end
