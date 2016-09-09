# @author  Ryan Lacey

class UserTrip < ActiveRecord::Base
    self.table_name = :users_trips
    belongs_to :user
    belongs_to :trip

    # Adds each user to trip if they are a member of the site.
    def self.add_users_to_trip(users, trip, current_user)
        if users
            for user in users do
                email = user[1]
                if User.exists?(email: email) and self.unique?(email, trip) and email != current_user.email
                    UserTrip.create(user_id: User.find_by_email(email).id, trip_id: trip)
                end
            end
        end
    end

    # Checks if user already has association with given trip
    def self.unique?(email, trip)
        UserTrip.where(user_id: User.find_by_email(email).id, trip_id: trip).count == 0
    end

end
