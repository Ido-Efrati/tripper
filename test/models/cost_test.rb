require 'test_helper'
#@author Ido Efrati
class CostTest < ActiveSupport::TestCase
   #tests get_user_name , getting the owner's name of a specific cost
   def test_get_user_name
   	user1 = users(:user_one)
   	cost1 = costs(:user1_cash1)
   	cost1.user_id = user1.id
   	cost1.save
   	assert_equal cost1.user_id,user1.id
	assert_equal user1.name ,cost1.get_user_name 
   end
end
