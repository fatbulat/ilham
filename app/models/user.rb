class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable

  has_many :written_fictions, foreign_key: "author_id", class_name: "Fiction", dependent: :destroy

  def remember_me
    true
  end
end