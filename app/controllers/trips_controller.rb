# @author Ido Efrati

class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy]
  before_action :require_login

  # GET /trips
  # GET /trips.json
  # Display all trips associated with logged in user
  def index
    @trips = current_user.trips
  end

  # GET /trips/1
  # GET /trips/1.json
  # Set data for total trip costs, total costs for a user on this trip, and the graphical display.
  def show
     if UserTrip.where(user_id: @current_user.id, trip_id: @trip.id) != []
  	   @totalcost = @trip.totalCost
       @userTotalCost =  @trip.userTotalCost(current_user.id)
       @totalTokenChart = total_tokens_pie_chart(@trip)
       @personalTokenChart = personal_tokens_column_chart(@trip.userTotalExcahnge(current_user.id))
       @allUsersInTrip = @trip.listUsersCosts
       @cashTokensRate = @trip.tokenExchange
     else
	     redirect_to trips_path
	   end
  end

  # GET /trips/new
  def new
    @trip = Trip.new
  end

  # GET /trips/1/edit
  def edit
  end

  # POST /trips
  # POST /trips.json
  # Create a trip, associate each trip member with the trip, and set default exchange rates.
  def create
    @trip = Trip.new(trip_name: trip_params[:trip_name], user_id: current_user.id)
    respond_to do |format|
      if @trip.save
        UserTrip.create(user_id: current_user.id, trip_id: @trip.id)
        UserTrip.add_users_to_trip(params[:trippers], @trip.id, current_user)
        Exchange.set_defaults(@trip.id)
        format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
        format.json { render action: 'show', status: :created, location: @trip }
      else
        format.html { render action: 'new' }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trips/1
  # PATCH/PUT /trips/1.json
  def update
    respond_to do |format|
      if @trip.update(trip_params)
        format.html { redirect_to @trip, notice: 'Trip was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    @trip.destroy
    respond_to do |format|
      format.html { redirect_to trips_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trip_params
      params.require(:trip).permit(:trip_name, :tripper)
    end

    def total_tokens_pie_chart(trip)
      data_table = GoogleVisualr::DataTable.new
      # verify that we have tokens to present, otherwise don't create columns
      sum = 0
      trip.user_trips.each do |user|
        sum += @trip.userTotalCost(user.user_id)
      end
      if sum >0
        data_table.new_column('string', 'Person')
        data_table.new_column('number', 'Tokens')
      end
      #if we created columns we'll add data to the pie chart
      data_table.add_rows(trip.user_trips.count)
      count = 0
      trip.user_trips.each do |user|
        if @trip.userTotalCost(user.user_id) > 0
          data_table.set_cell(count, 0, User.find(user.user_id).name)
          data_table.set_cell(count, 1, @trip.userTotalCost(user.user_id))
          count += 1
        end
      end
      opts = { :width => 550, :height => 250, :is3D => true }
      @piechart = GoogleVisualr::Interactive::PieChart.new(data_table, opts)
    end

    def personal_tokens_column_chart(values)
      data_table = GoogleVisualr::DataTable.new
      data_table.add_rows(1)
      data_table.new_column('string', '')
      values.each do |value|
        data_table.new_column('number', Exchange.find(value[0]).units)
      end
      data_table.set_cell(0, 0, '')
      count = 1
      values.each do |value|
        data_table.set_cell(0, count, Exchange.find(value[0]).rate*value[1])
        count += 1
      end
      opts = { :width => 550, :height => 250, :vAxis => {:title => '# of tokens'} ,:hAxis => { :title => 'Types of tokens'}}
      @colchart = GoogleVisualr::Interactive::ColumnChart.new(data_table, opts)
    end

end
