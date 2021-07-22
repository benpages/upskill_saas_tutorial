class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  belongs_to :plan
  has_one :profile
  
  attr_accessor :stripe_card_token
  # If Pro user passes validation (email, password, etc.),
  # then call Stripe and tell Strip to set up a subscription
  # upong charging the customer's card.
  # Stripe responds back with customeer data.
  # Store customer.id as the customer token and save the user.
  def save_with_subscription
    if valid?
      customer = Stripe::Customer.create(description: email, plan: 'price_1JErq4BW9P3FdmYGCJlmbHPg', card: stripe_card_token)
      self.stripe_customer_token = customer.id
      save!
    end
  end
end
