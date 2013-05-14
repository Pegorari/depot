class CombineItemsInCart < ActiveRecord::Migration
  def up
    # replace multiple items for a single product in a cart with a single item
    Cart.all.each do |cart|
      # count the number of each product in the cart
      sums = cart.cart_items.group(:product_id).sum(:quantity)

      sums.each do |product_id, quantity|
        if quantity > 1
          # remove individual items
          cart.cart_items.where(:product_id=>product_id).delete_all

          # replace with a single item
          cart.cart_items.create(:product_id=>product_id, :quantity=>quantity)
        end
      end
    end
  end

  def down
    # split items with quantity>1 into multiple items
    LineItem.where("quantity>1").each do |cart_items|
      # add individual items
      cart_items.quantity.times do 
        LineItem.create :cart_id=>cart_items.cart_id, :product_id=>cart_items.product_id, :quantity=>1
      end

      # remove original item
      cart_items.destroy
    end
  end

end
