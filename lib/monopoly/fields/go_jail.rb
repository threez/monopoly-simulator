module Monopoly
  module Fields
    class GoJail < Field
      include NotBuyable
  
      def enter_field(player)
        playing_field.go_to_jail player
      end
    end
  end
end
