require 'test_helper'
#@author Ido Efrati
class UserTest < ActiveSupport::TestCase
   
   #test that tokens are randomly generated
   def test_remember_token
      assert_not_equal  User.new_remember_token, User.new_remember_token
   end

   #test that a token digest always returns the same digest
   def test_encrypt
      token = User.new_remember_token
      digest = User.encrypt(token)
      assert_equal digest, User.encrypt(token)
   end

      def test_get_trip_costs
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
      #test  the user's cost
      assert_equal 150.0, user1.get_trip_costs(trip1.id).first.value
      assert_equal user1.id, user1.get_trip_costs(trip1.id).first.user_id
      assert_equal trip1.id, user1.get_trip_costs(trip1.id).first.trip_id
      assert_equal cost1.id, user1.get_trip_costs(trip1.id).first.id
      assert_equal exchange1.id, user1.get_trip_costs(trip1.id).first.exchange_id


   end


end



    # Find a user's costs for a specific trip
    #def get_trip_costs(trip_id)
     #   return self.costs.where(trip_id: trip_id)
    #end
