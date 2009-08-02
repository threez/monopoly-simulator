module Monopoly
  module Fields
    class Tax < Field
      include NotBuyable

      def initialize(name, price)
        super(name)
        @price = price
      end

      def enter_field(player)
        player.transfer_money_to(:bank, @price)
      end
    end
  end
end
