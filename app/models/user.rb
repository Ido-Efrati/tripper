# @author Ido Efrati

class User < ActiveRecord::Base

    has_many :trips, through: :user_trips
    has_many :user_trips, dependent: :destroy
    has_many :costs, dependent: :destroy

    # Validate that a user has a username, that its length is between 2-20 chars.
    validates :name, presence: true, length: { in: 2..20 }, uniqueness:true

    # Validate that a user has an email, that it fits a valid email format, and that the email adress is unique.
    # Uniqueness is not case sensitive (IDO@MIT.EDU is the same as ido@mit.edu)
    validates :email, presence: true, uniqueness: { case_sensitive: false }
    validates_format_of :email, :with => /@/

    # Verify that the password is encrypted to prevent plain text passwords in the db.
    # Validate the existence of a password and  password is at least 6 chars.
    has_secure_password
    validates :password, length: { minimum: 6 }

    # Methods to encrypt the users session
    def self.new_remember_token
        SecureRandom.urlsafe_base64
    end

    def self.encrypt(token)
        Digest::SHA1.hexdigest(token.to_s)
    end

    # Find a user's costs for a specific trip
    def get_trip_costs(trip_id)
        return self.costs.where(trip_id: trip_id)
    end

    private
        def create_remember_token
          self.remember_token = User.encrypt(User.new_remember_token)
        end
end
