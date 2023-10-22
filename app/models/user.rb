class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :nickname, uniqueness: true, allow_blank: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments
  has_many :likes

  # Ассоциации для подписчиков и подписок
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_one_attached :avatar

  # after_commit :resize_avatar, if: -> { avatar.attached? }

  def display_name
    nickname.present? ? nickname : email
  end

  def follow(other_user)
    following << other_user unless self == other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Post.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

  def relationship_with(user)
    active_relationships.find_by(followed_id: user.id)
  end

  private

  def resize_avatar
    avatar.variant(resize: "64x64").processed
  end
end
