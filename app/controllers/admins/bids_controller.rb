class Admins::BidsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_bid, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @bids = Bid.all
  end

  def show
  end

  def new
    @bid = Bid.new
  end

  def edit
  end

  def create
    @bid = Bid.new bid_params
    @bid.save
    redirect_to action: :index
  end

  def update
    @bid.update bid_params
    redirect_to action: :index
  end

  def destroy
    @bid.destroy
    redirect_to action: :index
  end

  private
    def set_bid
      @bid = Bid.find params[:id]
    end

    def bid_params
      params[:bid]
    end
end
