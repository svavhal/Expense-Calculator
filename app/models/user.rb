class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :members
  has_many :groups, through: :members

  validates :first_name, presence: true

  def name
  	"#{first_name} #{last_name}"
  end
end
