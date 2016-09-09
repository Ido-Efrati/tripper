require 'test_helper'
#@author ido efrati
class TripTest < ActiveSupport::TestCase

   # the test will test the total cost method.
   # by creating two users, each with a cost, and calculating their
   # trip's total costs.
   def test_totalCost
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
   	#create an exchange rate
   	exchange1 = exchanges(:trip1_dollars)
   	exchange1.trip_id = trip1.id
   	exchange1.save
   	#check the exchange belongs to a trip
   	assert_equal exchange1.trip_id,trip1.id
   	#create a cost for user1
   	cost1 = costs(:user1_cash1)
   	cost1.trip_id = trip1.id
   	cost1.user_id = user1.id
   	cost1.exchange_id = exchange1.id
   	cost1.save
   	#check that the cost belongs to trip1, user1 and has exchange_rate 1
   	assert_equal cost1.trip_id,trip1.id
   	assert_equal cost1.user_id,user1.id
   	assert_equal cost1.exchange_id,exchange1.id
	   assert_equal 150.0, cost1.value 
   	#create a cost for user2
   	cost2 = costs(:user1_cash2)
   	cost2.trip_id = trip1.id
   	cost2.user_id = user2.id
   	cost2.exchange_id = exchange1.id
   	cost2.save
   	#check that the cost belongs to trip1, user1 and has exchange_rate 1
   	assert_equal cost2.trip_id,trip1.id
   	assert_equal cost2.user_id,user2.id
   	assert_equal cost2.exchange_id,exchange1.id
	   assert_equal 115.0, cost2.value 
	   #check total cost method
   	assert_equal 530.0, trip1.totalCost
   end

   #test userTotalCost. Finds the total costs of a specific user
   def test_userTotalCost
   	trip1 = trips(:trip1)
   	user1 = users(:user_one)
   	#make user1 the owner of trip1
   	trip1.user_id = user1.id
   	trip1.save
   	#check trip1 owner
   	assert_equal user1.id , trip1.user_id
   	#create an exchange rate
   	exchange1 = exchanges(:trip1_dollars)
   	exchange1.trip_id = trip1.id
   	exchange1.save
   	#check the exchange belongs to a trip
   	assert_equal exchange1.trip_id,trip1.id
   	#create a cost for user1
   	cost1 = costs(:user1_cash1)
   	cost1.trip_id = trip1.id
   	cost1.user_id = user1.id
   	cost1.exchange_id = exchange1.id
   	cost1.save
   	#check that the cost belongs to trip1, user1 and has exchange_rate 1
   	assert_equal cost1.trip_id,trip1.id
   	assert_equal cost1.user_id,user1.id
   	assert_equal cost1.exchange_id,exchange1.id
	assert_equal 150.0, cost1.value 
   	assert_equal 300.0, trip1.userTotalCost(user1.id)
   end

   # tests userTotalExcahnge. Returns an array of exchange_id and the cost value
   def test_userTotalExcahnge
   	trip2 = trips(:trip2)
   	user1 = users(:user_one)
   	#make user1 the owner of trip2
   	trip2.user_id = user1.id
   	trip2.save
   	#check trip2 owner
   	assert_equal user1.id , trip2.user_id
   	#create an exchange rate
   	exchange2 = exchanges(:trip2_dollars)
   	exchange2.trip_id = trip2.id
   	exchange2.save
   	#check the exchange belongs to a trip
   	assert_equal exchange2.trip_id,trip2.id
   	#create a cost for user1
   	cost2 = costs(:user1_cash2)
   	cost2.trip_id = trip2.id
   	cost2.user_id = user1.id
   	cost2.exchange_id = exchange2.id
   	cost2.save
   	#check that the cost belongs to trip2, user1 and has exchange_rate 1
   	assert_equal cost2.trip_id,trip2.id
   	assert_equal cost2.user_id,user1.id
   	assert_equal cost2.exchange_id,exchange2.id
	assert_equal 115.0, cost2.value 
   	assert_equal 287.5, trip2.userTotalCost(user1.id)
   	assert_equal exchange2.id , trip2.userTotalExcahnge(user1.id).first[0]
   	assert_equal cost2.value , trip2.userTotalExcahnge(user1.id).first[1]
   end

   # gets trippers details 
   def test_listUsersCosts
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

   	assert_equal 1, trip1.listUsersCosts.size
   	assert_equal user2.id, trip1.listUsersCosts[0].id
   	assert_equal user2.name, trip1.listUsersCosts[0].name
   	assert_equal user2.email, trip1.listUsersCosts[0].email
   end

   #test the token->dollars tokenExcahnge method
   def test_tokenExchange
   	trip1 = trips(:trip1)
   	user1 = users(:user_one)
   	user2 = users(:user_two)
   	#make user1 the owner of trip1
   	trip1.user_id = user1.id
   	trip1.save
   	#check trip1 owner
   	assert_equal user1.id , trip1.user_id
   	#create an exchange rate
   	exchange1 = exchanges(:trip1_dollars)
   	exchange1.trip_id = trip1.id
   	exchange1.save
   	#check the exchange belongs to a trip
   	assert_equal exchange1.trip_id,trip1.id
   	assert_equal 2.0, trip1.tokenExchange
   end
end
