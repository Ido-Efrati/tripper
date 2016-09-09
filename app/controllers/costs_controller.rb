# @author Ryan Lacey

class CostsController < ApplicationController

  before_action :require_login
  before_action :set_cost, only: [:show, :edit, :update, :destroy]
  before_action :set_trip, only: [:index, :new, :create, :destroy]

  # GET /costs
  # GET /costs.json
  def index
    @costs = Cost.where(trip_id: @trip.id)
  end

  # GET /costs/1
  # GET /costs/1.json
	# Shows the details of the cost for the trip.
  def show
  end

  # GET /costs/new
	# Make a new cost.
  def new
    @cost = Cost.new
  end

  # POST /costs
  # POST /costs.json
  def create
    @cost = Cost.new(cost_params)
    @cost.user_id = current_user.id
	  @cost.trip_id = @trip.id
    respond_to do |format|
      if @cost.save
        format.html { redirect_to @cost, notice: 'Cost was successfully created.' }
        format.json { render action: 'index', status: :created, location: @cost }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @cost.errors, status: :unprocessable_entity }
        format.js 
      end
    end
  end

  # DELETE /costs/1
  # DELETE /costs/1.json
  def destroy
    @cost.destroy
    respond_to do |format|
      format.html { redirect_to trip_costs_url(@trip) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cost
      @cost = Cost.find(params[:id])
    end

    def set_trip
      @trip = Trip.find(params[:trip_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cost_params
      params.require(:cost).permit(:value, :description, :trip_id, :exchange_id)
    end
end
