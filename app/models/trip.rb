# @author  Ido Efrati

class Trip < ActiveRecord::Base
	has_many :users, through: :user_trips
    has_many :user_trips, dependent: :destroy
    has_many :costs, dependent: :destroy
    has_many :exchanges, dependent: :destroy

    validates :trip_name, presence: true

    # Calculate total tokens cost of trip
	def totalCost
		finalValue = 0
		@totalExchGrouped = self.costs.group("exchange_id").sum('value')
		@totalExchGrouped.each do |exch|
			finalValue += Exchange.find(exch[0]).rate*exch[1]
		end
		return finalValue
	end

	# Calculate total tokens cost of trip for a specific user
	def userTotalCost(current)
		 finalValue = 0
		 @groupedBy = self.costs.where(user_id: current).group("exchange_id").sum('value')
		 @groupedBy.each do |exch|
		 	finalValue += Exchange.find(exch[0]).rate*exch[1]
		 end
		 return finalValue
	end

	# Calculate token cost by exchange resource for a specific user
	def userTotalExcahnge(current)
		self.costs.where(user_id: current).group("exchange_id").sum('value')
	end

	# Aggregate users of given trip
	def listUsersCosts
	    return self.user_trips.collect {|usertrip| User.find(usertrip.user_id)}
	end

	# Gets the exchange rate of dollars in s specific trip
	def tokenExchange
		rate = Exchange.where(trip_id: self.id, units: "dollars").first.rate
		return rate
	end

end
