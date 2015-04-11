class ReservationsController < ApplicationController
  def new
    @reservation = Reservation.new
    @max_bags_allowed = Locker.max_bags_allowed
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      redirect_to @reservation, notice: "Reservation Made. "\
        "Please receive #{@reservation.customer.first_name}'s bag(s)."
    else
      @max_bags_allowed = Locker.max_bags_allowed
      render 'new'
    end
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def destroy
    Reservation.find(params[:id]).destroy
    redirect_to root_path
  end

  def search
  end

  def searching
    @reservation = Reservation.
                     find_by(number: params[:reservation_number].upcase)
    if @reservation
      redirect_to @reservation, notice: "Please return "\
        "#{@reservation.customer.first_name}'s bag(s)."
    else
      flash.now[:error] = "No Reservation Found. "\
        "Please search from list provided."
      render 'search'
    end
  end

  def print_ticket
    @reservation = Reservation.find(params[:id])
  end

  def print_lockers
    @reservation = Reservation.find(params[:id])
  end


  private


  def reservation_params
    params.require(:reservation).permit(:bags_owner, :small,
                                        :medium,     :large)
  end
end
