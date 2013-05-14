class Product < ActiveRecord::Base
  default_scope :order => 'title'
  has_many :cart_items
  attr_accessible :description, :image_url, :price, :title
  validates :description, :image_url, :price, :title, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :title, :uniqueness => true
  validates :image_url, :format => {:with => %r{\.(gif|jpg|png)$}i, :message => 'must be a URL for GIF, JPG or PNG image.'}

  before_destroy :ensure_not_referenced_by_any_cart_item

  def ensure_not_referenced_by_any_cart_item
    if cart_items.count.zero?
      return true
    else
      errors.add(:base, 'Cart Items present' )
      return false
    end
  end

end
