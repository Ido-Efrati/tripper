# @author Jesika Haria

class Cost < ActiveRecord::Base

	has_one :user
    has_one :exchange
    belongs_to :trip

	validates :value, presence: true, numericality: { greater_than: 0 }
	validates :exchange_id, presence: true

	# Find the name of user that the cost belongs to
    def get_user_name
        return User.find(self.user_id).name
    end

    # Find the units that the cost is in
    def get_units
        return Exchange.find(self.exchange_id).units
    end

    # Convert cost value into tokens
    def to_tokens
        Exchange.find(self.exchange_id).rate * self.value
    end
end
