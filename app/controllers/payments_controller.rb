class PaymentsController < ApplicationController

  before_action :authenticate_user!, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  def index
  end

  def create
    @fiction = Fiction.find_by_id :fiction_id
    if @fiction
      @sum = @fiction.price
      @payment = current_user.payments.create(fiction_id: payment_params[:fiction_id], sum: @sum)
      redirect_to "https://unitpay.ru/pay/6493-da044?sum=#{ @payment.sum }&account=#{ @payment.id }&desc=Purchase+of+a+literary+work&hideDesc=true&"
    end
  end

  def confirm
    @payment = Payment.find_by_id(params[:params][:account])
    if @payment
      if @payment.update_attributes(operator:    params[:params][:operator],
                                    paymentType: params[:params][:paymentType],
                                    phone:       params[:params][:phone],
                                    sign:        params[:params][:sign],
                                    profit:      params[:params][:profit],
                                    unitpayId:   params[:params][:unitpayId],
                                    status:      params[:method])
        success("Success")
      end

      if @payment.status == 'pay'
        @user = User.find_by_id(@payment.user_id)
        @user.buy!(@payment.fiction_id)
      end

    else
      error("Payment not found")
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:fiction_id)
  end

  def error(msg)
    render json: { error: { code: -32000, message: msg } }
  end

  def success(msg)
    render json: { result: { message: msg } }
  end
end
