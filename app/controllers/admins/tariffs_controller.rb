class Admins::TariffsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_tariff, only: [:show, :edit, :update, :destroy]

  def index
    @tariffs = Tariff.all
  end

  def new
    @tariff = Tariff.new
  end

  def create
    @tariff = Tariff.create tariff_params
    redirect_to action: :index
  end

  def update
    @tariff.update tariff_params
    redirect_to action: :index
  end

  def destroy
    @tariff.destroy
    redirect_to action: :index
  end

  private
    def set_tariff
      @tariff ||= Tariff.find params[:id]
    end

    def tariff_params
      params.require(:tariff).permit(:name, :description, :price_per_month, :duration)
    end
end
