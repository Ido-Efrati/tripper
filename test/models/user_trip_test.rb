require 'test_helper'

class UserTripTest < ActiveSupport::TestCase

 # check if a user is already part of a trip
 # return true if is not part of the trip, and false if alreay is part of a trip
 def test_unique_user_not_exist
   	trip1 = trips(:trip1)
   	user1 = users(:user_one)
   	user2 = users(:user_two)
   	#make user1 the owner of trip1
   	trip1.user_id = user1.id
   	trip1.save
   	#check trip1 owner
   	assert_equal user1.id , trip1.user_id
   	assert_equal true, UserTrip.unique?(user2.email,trip1)
   end

 def test_unique_user_exist
   	trip1 = trips(:trip1)
   	user1 = users(:user_one)
   	user2 = users(:user_two)
   	#make user1 the owner of trip1
   	trip1.user_id = user1.id
   	trip1.save
   	#check trip1 owner
   	assert_equal user1.id , trip1.user_id
   	#add a tripper to a trip
    tripper = user_trips(:user_to_trip)
   	tripper.trip_id = trip1.id
   	tripper.user_id = user2.id
   	tripper.save
   	# check tripper's data
   	assert_equal tripper.trip_id , trip1.id
   	assert_equal tripper.user_id , user2.id
   	assert_equal false, UserTrip.unique?(user2.email,trip1)
   end
end
