class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :trackable

  field :name,               :type => String
  field :username,           :type => String
  ## Database authenticatable
  field :email,              :type => String
  field :encrypted_password, :type => String

  ## Token authenticatable
  field :authentication_token, :type => String

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  has_many :posts, :dependent => :destroy
  has_many :trips, :dependent => :destroy

  before_save :ensure_authentication_token
  after_create :mail_user

  def mail_user
    UserMailer.welcome(id.to_s).deliver_later
  end

  def ensure_authentication_token
    return if authentication_token.present?
    self.authentication_token = generate_authentication_token
  end

  def generate_authentication_token
    loop do
      token = SecureRandom.urlsafe_base64(nil, false)
      break token unless User.where(:authentication_token => token).any?
    end
  end
end
