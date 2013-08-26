class User < ActiveRecord::Base
  ROLES = %w[dbausr supervisor user banned]
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles, :avatar
  # attr_accessible :title, :body
  attr_accessible :name, :admin

  # This is for the example
  has_many :reminders
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end

  has_attached_file :avatar, styles: {
    small:  '25x25>',
    thumb:  '100x100>',
    medium: '200x200>',
    large:  '300x300>'
  }
  
  # Enable papertrail on this model
  # Ignore fields that are not critical, and do not store s3 information
  has_paper_trail only: [:email, :encrypted_password, :roles_mask],
                  skip: [:avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at]

  include Rails.application.routes.url_helpers

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
    self.save
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def is?(role)
    roles.include?(role.to_s)
  end

end
