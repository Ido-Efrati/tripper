require 'test_helper'
#author Ido Efrati
class ExchangeTest < ActiveSupport::TestCase
   #tests get_excahnge_select, returns a list of exchange units and their ids
   def test_get_exchange_select
   	trip1 = trips(:trip1)
   	#create an exchange rate
   	exchange1 = exchanges(:trip1_dollars)
   	exchange1.trip_id = trip1.id
   	exchange1.save
   	#check the exchange belongs to a trip
   	assert_equal exchange1.trip_id,trip1.id
   	#create an exchange rate
   	exchange2 = exchanges(:trip1_hours)
   	exchange2.trip_id = trip1.id
   	exchange2.save
   	#check the exchange belongs to a trip
   	assert_equal exchange2.trip_id,trip1.id
   	assert_equal [exchange1.units, exchange1.id],Exchange.get_exchange_select(trip1.id)[0]
   	assert_equal [exchange2.units, exchange2.id],Exchange.get_exchange_select(trip1.id)[1]
   	assert_equal 2,Exchange.get_exchange_select(trip1.id).size
   end

   # tests can_delete. Will return false if the exchange units are dollars, and true otherwise
   def test_can_delete
   	trip1 = trips(:trip1)
   	#create an exchange rate
   	exchange1 = exchanges(:trip1_dollars)
   	exchange1.trip_id = trip1.id
   	exchange1.save
   	#check the exchange belongs to a trip
   	assert_equal exchange1.trip_id,trip1.id
   	#create an exchange rate
   	exchange2 = exchanges(:trip1_hours)
   	exchange2.trip_id = trip1.id
   	exchange2.save
   	#check the exchange belongs to a trip
   	assert_equal exchange2.trip_id,trip1.id
   	assert_equal false,Exchange.can_delete(exchange1.id)
   	assert_equal true,Exchange.can_delete(exchange2.id)
   end



end
