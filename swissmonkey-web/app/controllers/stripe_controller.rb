# Handles stripe-related functionality
class StripeController < ApplicationController
  before_action :set_coupon, only: [:apply_coupon]
  before_action :validate_coupon_use, only: [:apply_coupon]

  def delete_card
    # TODO: finish this
    # customer_token = params[:customer_id]
    # card_details = payment_card_details::where('stripe_customer_id', '=', customer_token).get().first()
    # if card_details
    #   card_details.is_deleted = 1
    #   begin
    #     card_details.save
    #   rescue => ex
    #     Airbrake.notify ex
    #   end
    #   cancel_subscription_plans(customer_token)
    #   jobs = job_plan_relation::getSubscribedJobsList(current_user.id)
    #   jobs.each do |job|
    #     job_plan = job_plan_relation::where('job_id', '=', job.job_id)
    #                  .get()
    #                  .first()
    #     if job_plan
    #       job_plan.auto_renew = 0
    #       job_plan.subscription_token = NULL
    #       job_plan.save!
    #     end
    #   end
    #   respond_with_success 'Card removed'
    # else
    #   respond_with_try_again
    # end
    respond_with_success 'Temporary'
  end

  def apply_coupon
    redemptions_used = @selected_coupon.metadata['times_redeemed']
    max_redemptions = @selected_coupon.max_redemptions

    if redemptions_used && max_redemptions && redemptions_used >= max_redemptions
      return respond_with_error('This coupon has already been used. Please try using different coupon code')
    end

    render json: { Success: "Coupon #{@coupon_code} applied", charge: charge_amount, applied: true }
  end

  def check_location_payment
    # $session = Session::get('id');
    # $location_id = params[:location_id]
    # date1 = Time.zone.now
    #
    # $job_plan = user_subscription::where('location_id', '=', $location_id)
    # ->where('user_id', '=', $session)
    # ->where('closed_date', '>', $date1)
    # ->count();

    # @TODO: figure this out

    render json: { success: true, jobcount: job_plan }
  end

  private

  def cancel_subscription_plans(customer_token)
    customer = Stripe::Customer.retrieve(customer_token)
    return unless customer&.subscriptions&.data
    customer.subscriptions.data.each { |subs| cancel_subscription(subs.id) }
  end

  def cancel_subscription(subscription_id)
    subscription = Stripe::Subscription.retrieve(subscription_id)
    subscription.cancel
    true
    # rescue => ex
    #   Airbrake.notify ex
    #   false
  end

  def set_coupon
    @coupon_code = params[:coupon_code]

    # begin
    @selected_coupon = Stripe::Coupon.retrieve(@coupon_code)
    # rescue => ex
    #   Airbrake.notify ex
    #   return respond_with_error('Invalid Coupon code')
    # end

    head 404 unless @selected_coupon

    respond_with_error('Invalid Coupon') unless @selected_coupon.redeem_by
    respond_with_error('Coupon expired') if Date.parse(@selected_coupon.redeem_by) < Time.zone.today
  end

  def charge_amount
    if @selected_coupon.amount_off
      49 - @selected_coupon.amount_off
    elsif @selected_coupon.percent_off
      49 - (49 * (@selected_coupon.percent_off / 100))
    else
      49
    end
  end

  def validate_coupon_use
    return unless @selected_coupon.duration == 'once' && current_user.stripe_customer_id &&
                  @selected_coupon.metadata[current_user.stripe_customer_id]
    respond_with_error('Coupon used already')
  end
end
