class Order < ActiveRecord::Base
  has_many :cart_items, :dependent => :destroy
  attr_accessible :email, :name, :pay_type
  PAYMENT_TYPES = [ "Check" , "Credit card" , "Purchase order" ]
  validates :name, :email, :pay_type, :presence => true
  validates :pay_type, :inclusion => PAYMENT_TYPES
end
