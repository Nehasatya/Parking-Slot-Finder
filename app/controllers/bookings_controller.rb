class BookingsController < ApplicationController

  def new
    @booking = Booking.new
  end

  def create

    # In case of a new vehicle
    reg_no = params[:booking][:vehicle_reg_no]
    @vehicle = Vehicle.find_by(reg_no: reg_no)
    if @vehicle.nil?
      @vehicle = Vehicle.create(reg_no: reg_no)
    end

    # In case of vehicle already parked
    @booking = Booking.on_date(Date.today).on_same_reg_no(reg_no).last

    if (!@booking.nil? && @booking.out_time.nil?)
      redirect_to root_path, notice: "Vehicle already Booked Today for Slot No: #{@booking.slot_id}"

    else

        #  In case of it is a valid booking
        nearest_slot = find_nearest_slot

        @booking = Booking.create(bookings_params.merge(slot_id: nearest_slot.id, vehicle_id: @vehicle.id).except(:vehicle_reg_no))

         # Saving if it is a new Vehicle record
        if @vehicle.new_record?
          # @vehicle.update(first_entry_time: @booking.in_time)
          if !@vehicle.save
            render :new, status: :unprocessable_entity
            return
          end
        end
        if  @booking.save
          nearest_slot.update(status: 'Booked')
          respond_to do |format|
            format.html{ redirect_to booking_path(@booking)}
          end
        else
          render :new
        end
    end
  end

  def find_nearest_slot

    entry = Entry.find(params[:booking][:entry_id])
    nearest_slot = Slot.all.available_slots.nearest_slot(entry)

    if nearest_slot.nil?
        raise "error"
    else
      nearest_slot
    end

  end

  def show
    @booking = Booking.find(params[:id])
  end

  def slot_history

    unless params[:date].blank?
      @bookings = Booking.on_date(params[:date]).paginate(page: params[:page], per_page: 5)
    else
      @bookings = Booking.all.paginate(page: params[:page], per_page: 5)
    end
  end

  def vehicle_history

    unless params[:vehicle_reg_no].blank?
      @bookings = Booking.on_same_reg_no(params[:vehicle_reg_no]).paginate(page: params[:page], per_page: 5)
  else
      @bookings = Booking.all.paginate(page: params[:page], per_page: 5)
    end
  end

  def first_entry

    @vehicles = Vehicle.all.paginate(page: params[:page], per_page: 5)

  end

  def free_slot

    # if params.has_key?(:vehicle_reg_no)
    #   vehicle_id = Vehicle.find_by(reg_no: params[:vehicle_reg_no]).id
    #   @booking =  Booking.where(slot_id: params[:slot_id], vehicle_id: vehicle_id, out_time:nil).last
    if params.has_key?(:id)
      @booking = Booking.find(params[:id])
      if !@booking.nil? && @booking.out_time.nil?
      if @booking.update(out_time: Time.now)
        @booking.slot.update(status: 'Available')
      end
    end
   end
  end

  def close_shop
    if params[:commit].eql?("Close Shop")
      @open_bookings = Booking.where(out_time: nil)
      @open_bookings.each do |open_booking|
        open_booking.update(out_time: Time.now)
        open_booking.slot.update(status: 'Available')
      end
      redirect_to root_path, notice: 'All Open Bookings Close'
    end
  end

  private

  def bookings_params
    params.require(:booking).permit(:vehicle_reg_no, :in_time)
  end

end