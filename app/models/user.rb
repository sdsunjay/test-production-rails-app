class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  # attr_accessible :email, :last_name, :first_name, :gender, :uid, :profile_picture, :link, :provider, :oauth_token, :oauth_expires_at    
  validates_presence_of :first_name, :last_name, :email, :uid
  validates_uniqueness_of :uid, :email


  def self.find_for_oauth(auth, signed_in_resource = nil)

    #puts "auth token is \n"
    #puts auth
    
    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email
      puts auth.extra.raw_info.age_range.min[1]
      puts auth.extra.raw_info.age_range.max[1]

      # Create the user if it's a new registration
      if user.nil?
        user = User.create(first_name:auth.extra.raw_info.first_name,last_name:auth.extra.raw_info.last_name,gender:auth.extra.raw_info.gender,uid:auth.uid,profile_picture:auth.info.image,link:auth.extra.raw_info.link,email: auth.info.email,age_min:auth.extra.raw_info.age_range.min[1],age_max:auth.extra.raw_info.age_range.max[1], password: Devise.friendly_token[0,20])
        #user.skip_confirmation!
	#user.skip_confirmation! if user.respond_to?(:skip_confirmation)
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
end


