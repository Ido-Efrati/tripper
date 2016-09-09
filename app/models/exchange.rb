# @author Jesika Haria

class Exchange < ActiveRecord::Base

	belongs_to :trip
	has_many :costs, dependent: :destroy

	validates :units, presence: true, uniqueness: { scope: :trip_id }
  validates :rate, presence: true, numericality: { greater_than: 0 }

  # Default resources and rates associated with trip on creation
  def self.set_defaults(trip_id)
  	Exchange.create(rate: 1, :units => "dollars", trip_id: trip_id)
  	Exchange.create(rate: 1, :units => "hours driven", trip_id: trip_id)
  end

  # Returns zip of exchange resource IDs with exchange resource name
  # eg (1, 'dollars') (2, 'hours driven')
  def self.get_exchange_select(trip_id)
      exchanges = Trip.find(trip_id).exchanges
      exchange_ids = exchanges.collect { |exchange| exchange.id }
      exchange_units = exchange_ids.collect { |exchange_id| Exchange.find(exchange_id).units }
      return exchange_units.zip(exchange_ids)
  end

  # Returns true if the unit is dollars and false otherwise
  # Used to ensure that you can't change the name for dollars or delete it
  def self.can_delete(exchange_id)
    return Exchange.find(exchange_id).units != "dollars"
  end

end
