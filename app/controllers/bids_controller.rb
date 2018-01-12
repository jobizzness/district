class BidsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bid, only: :edit
  before_action :set_project, only: [:create]
  before_action :get_project, only: [:index]
  before_action :take_project_and_bid_for_win, only: [:win]

  def index
    @bids = @project.bids.sort_by_newest    
    return @project, @bids
  end

  def edit    
  end

  def create
    if current_user.idea? || (current_user.tariff_id == 0 || current_user.tariff_expired?)
      return projects_path(@project, flash: { notice: 'You can\'t post bid.' })
    end

    form_params.merge!(project_id: params[:project_id])
    bid = current_user.bids.new form_params

    if bid.save
      redirect_to project_path(@project)
    else
      redirect_to :back, alert: 'Somthing went wrong...'
    end
  end

  def update
    bid = current_user.bids.find params[:id]
    if bid.win_id.nil? && bid.update_attributes(form_params)
      redirect_to project_path(params[:project_id]), notice: 'Bid is successfully updated'
    else
      redirect_to :back, alert: 'Somthing went wrong...'
    end
  end

  def destroy
    bid = current_user.bids.find params[:id]
    if bid.win_id.nil? && bid.destroy
      redirect_to project_path(params[:project_id]), notice: 'Bid is successfully deleted'
    else
      redirect_to :back, alert: 'Somthing went wrong...'
    end
  end

  def win
    message, status = 
      if @bid.not_win?
        order_params = {
          title: 'Purchase the service of project',
          amount: @bid.total_price,
          bid: @bid
        }

        amount = @bid.total_price * 100 # in cent
        fee = (amount * (5.0 / 100)).to_i # 5%

        begin
          charge_attrs = {
            amount: amount,
            currency: 'usd',
            source: params[:stripe_token],
            description: "Purchase the service of project ##{@project.id}",
            application_fee: fee
          }

          Stripe::Charge.create(charge_attrs, @bid.user.stripe_secret_key)

          @project.update(status: :in_work)
          @project.create_win(bid: @bid)
          current_user.orders.create(order_params)

          ['Order create successfully.', :ok]
        rescue => e
          [e.message, :bad]
        end
      else
        ['Bid already won.', :bad]
      end

    render json: { message: message }, status: status
  end

  def create_chat_message
    message = ChatMessage.create(chat_message_params)
    render partial: 'bids/message', locals: { message: message }, status: :ok
  end

  def chat_messages
    messages = ChatMessage.includes(user: [:companies]).where(bid_id: params[:bid_id])
    render partial: 'bids/messages', locals: { messages: messages }, status: :ok
  end

  def deliver_project
    project = Project.in_work.find(params[:project_id])
    bid = project.bid

    if bid.user_id == current_user.id
      chat_message = ChatMessage.create(bid_id: bid.id, user_id: current_user.id, body: "Tracking number:\n#{params[:tracking_number]}")

      params[:photos].each do |photo|
        ShipmentPhoto.create bid_id: bid.id, chat_message_id: chat_message.id, file: photo[1]
      end

      BidMailer.deliver_project(params[:tracking_number], bid, project).deliver
    else
      flash[:notice] = 'You don\'t have access for this bid.'
    end

    render json: {}, status: :ok
  end

  def complete
    project = current_user.projects.find(params[:project_id])
    project.update(status: :completed) if project.present?
    redirect_to :back
  end

  def dispute
    project = Project.in_work.find(params[:project_id])
    bid = project.bid

    if [project.user_id, bid.user_id].include?(current_user.id)
      cookies[:dispute_success] = true
      project.update(status: :disputed)
      recipient = project.user_id == current_user.id ? bid.user : project.user
      BidMailer.dispute(params[:subject], recipient, bid, project).deliver
    else
      flash[:notice] = 'You don\'t have access.'
    end

    redirect_to project_path(project)
  end

  def revise
    bid = current_user.bids.wins.not_revised.find params[:id]
    bid.update is_revised: true
    redirect_to :back
  end

  private
    def form_params
      params.require(:form).permit!
    end

    def set_bid
      @bid = current_user.bids.find params[:id]
    end

    def set_project
      @project = Project.opened.find(params[:project_id])
    end

    def get_project
      if current_user.projects.where(id: params[:id]).first
        @project = Project.find(params[:id])
      else
        redirect_to root_path 
      end
    end

    def take_project_and_bid_for_win
      @project = current_user.projects.find(params[:project_id])
      @bid = @project.bids.find(params[:id])
    end

    def chat_message_params
      params.permit(:bid_id, :user_id, :body)
    end
end
