# @author Jesika Haria

class ExchangesController < ApplicationController

	before_action :set_exchange, only: [:show, :edit, :update, :destroy]
	before_action :require_login

  # GET /exchanges
  # GET /exchanges.json
	def index
		if params[:trip_id] != nil
			redirect_to '/trips/' + params[:trip_id].to_s
		else
			flash[:notice] = "You can view exchanges on the home page of any of your trips."
			redirect_to trips_path
		end
	end

  # GET /exchanges/1
  # GET /exchanges/1.json
  def show
  	trip_id = @exchange.trip_id
  	redirect_to '/trips/' + trip_id.to_s
  end

  # GET /exchanges/new
  def new
    @exchange = Exchange.new
  end

  # GET /exchanges/1/edit
  def edit
	  @trip_id = params[:trip_id]
		if UserTrip.where(user_id: @current_user.id, trip_id: @exchange.trip_id) == []
			redirect_to trips_path
		end
  end

  # POST /exchanges
  # POST /exchanges.json
  def create
    @exchange = Exchange.new(exchange_params)
    respond_to do |format|
      if @exchange.save
        format.html { redirect_to @exchange, notice: 'Exchange was successfully created.' }
        format.json { render action: 'show', status: :created, location: @exchange }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @exchange.errors, status: :unprocessable_entity }
        format.js
      end
    end
    return
  end

  # PATCH/PUT /exchanges/1
  # PATCH/PUT /exchanges/1.json
  def update
    respond_to do |format|
      if @exchange.update(exchange_params)
        format.html { redirect_to @exchange, notice: 'Exchange was successfully updated.' }
        format.json do
        render :json => @exchange.to_json, :layout => false
        end
      else
        format.html { render action: 'edit' }
        format.json { render json: @exchange.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exchanges/1
  # DELETE /exchanges/1.json
  def destroy
		if UserTrip.where(user_id: @current_user.id, trip_id: @exchange.trip_id) == []
			redirect_to trips_path
		else
			if Cost.where(exchange_id: @exchange.id) != []
				redirect_to :back,
        :flash => { :error => "Cannot delete exchange because it is associated with trip costs. Please remove all costs using this exchange before deleting." }
							return
			else
        if Exchange.can_delete(@exchange.id) == false
          redirect_to :back, :flash => { :error => "Cannot delete dollar exchange"}
          return
        end
     		@exchange.destroy
      	respond_to do |format|
        	format.html { redirect_to :back }
        	format.json { head :no_content }
  			end
  		end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exchange
      @exchange = Exchange.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exchange_params
      params.require(:exchange).permit(:rate, :units, :trip_id)
    end
end
