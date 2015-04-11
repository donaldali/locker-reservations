class ReservationsController < ApplicationController
  def new
    @reservation = Reservation.new
    @max_bags_allowed = Locker.max_bags_allowed
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      redirect_to @reservation, notice: "Reservation Made"
    else
      @max_bags_allowed = Locker.max_bags_allowed
      render 'new'
    end
  end

  def show
    @reservation = Reservation.find(params[:id])
  end


  private


  def reservation_params
    params.require(:reservation).permit(:bags_owner, :small,
                                        :medium,     :large)
  end
end
